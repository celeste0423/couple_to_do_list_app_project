import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


class PurchaseApi{
  static const _apiKey ='sk_ypUPLcxTrNazkrXednZTxUwJywjnJ';

  static Future init()async{
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
  }

  static Future<List<Offering>> fetchOffers() async {
    try{
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    }on PlatformException catch(e){
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package)async{
    try{
      await Purchases.purchasePackage(package);
      return true;
    }catch(e){
      return false;
    }
  }

}

Future fetchOffers(context) async {
  final offerings = await PurchaseApi.fetchOffers();

  if (offerings.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error error error')));
  } else {
    final packages = offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList();

    PaywallWidget(int packagenumber){
      return Container(
        height: 200,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6.0),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(2.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        child: ListTile(
          trailing: Text(packages[packagenumber].storeProduct.priceString),
          leading: Image.asset('assets/images/diamond.png', width: 40,),
          title:  Text(packages[packagenumber].storeProduct.title,
            style: const TextStyle(
            ),
          ),
          subtitle: Text(packages[packagenumber].storeProduct.description),
          onTap: () async{
            await PurchaseApi.purchasePackage(packages[packagenumber]);
            //todo: 오류방지위한 주석. 여기서 토큰을 주면 됨.
          //  Provider.of<RevenueCatProvider>(context, listen: false).refreshhasAccess();

            Navigator.pop(context);
          },
        ),
      );
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PaywallWidget(0);
        });
    final offer = offerings.first;
    print(packages);
    print(packages.runtimeType);
    print('offer: $offer');

  }

}


//유료화 하고 싶으면 아래 comment만 다시 살리고 bool _hasAccess = false; 로 두면됨 !!!!!
class RevenueCatProvider extends ChangeNotifier{
  bool _hasAccess = true;
  bool get hasAccess => _hasAccess;

  refreshhasAccess(){
    init();
  }
//유료화 하고 싶으면 아래 comment만 다시 살리고 bool _hasAccess = false; 로 두면됨 !!!!!

  Future init()async{
    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // _hasAccess = customerInfo.entitlements.all['all_subjects']!.isActive;
    // notifyListeners();
  }
}