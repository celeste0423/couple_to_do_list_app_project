import 'package:couple_to_do_list_app/features/auth/controller/viewmodel.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final MainViewModel kakaoviewModel;
  final currentgroupindex;
  const LoadingScreen(this.kakaoviewModel, this.currentgroupindex, {Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {

  // List<String> groupkeys=[];
  // _performGroupSingleFetch ()async{
  //   await reference!.child('GroupMembers').get().then((snapshot) {
  //     print(snapshot.value.runtimeType);
  //     final x = snapshot.value as Map;
  //     print(x);
  //     Map reversedx = x.map((k,v)=>MapEntry(v, k));
  //     print(reversedx);
  //     for(dynamic z in x.values){
  //       if(z[widget.kakaoviewModel.user!.id.toString()]==true)
  //         groupkeys.add(reversedx[z]);
  //     }
  //     print(x);print(x);print(x);
  //     setState(() {
  //       print(groupkeys);
  //       print('groups 이거');
  //       print(groups);
  //     });
  //   });
  //
  //   await reference!.child('Groups').get().then((snapshot) {
  //     print((snapshot.value as Map).runtimeType);
  //     // final group = Group.fromSnapshot(snapshot);
  //     setState(() {
  //       for(String i in groupkeys){
  //          Map map = (snapshot.value as Map)[i] as Map;
  //         groups.add(Group.fromgcck(map['groupName'], map['content'], map['createTime'], i));
  //       }
  //       print('groups 이거');
  //       print(groups);
  //       // if(group.memberList.contains(widget.kakaoviewModel.user?.id.toString()))
  //       //   groups.add(group);
  //
  //     });
  //   });
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>MainScreen(widget.kakaoviewModel, groups, 0)));
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   //read the db for groups and such..
  //   _database = FirebaseDatabase.instance;
  //   reference = _database!.ref();
  //
  //   _performGroupSingleFetch();
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('loadingscreen')),
      body: Center(
        child: Text('loading screen')
    ));
  }
}
