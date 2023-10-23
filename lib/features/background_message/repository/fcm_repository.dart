import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/device_token_model.dart';

class FCMRepository {
  FCMRepository();

  Future<void> setDeviceToken(
    DeviceTokenModel deviceTokenData,
  ) async {
    await FirebaseFirestore.instance
        .collection('deviceToken')
        .doc(deviceTokenData.tid)
        .set(deviceTokenData.toJson());
  }

  Future<void> updateDeviceToken(
    DeviceTokenModel deviceTokenData,
  ) async {
    await FirebaseFirestore.instance
        .collection('deviceToken')
        .doc(deviceTokenData.tid)
        .update(deviceTokenData.toJson());
  }

  Future<void> deleteDeviceToken(
    String tid,
  ) async {
    await FirebaseFirestore.instance
        .collection('deviceToken')
        .doc(tid)
        .delete();
  }

  Future<DeviceTokenModel?> getDeviceTokenByUid(String uid) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('deviceToken')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs[0] as Map<String, dynamic>;
      final deviceTokenData = DeviceTokenModel.fromJson(data);
      return deviceTokenData;
    } else {
      return null;
    }
  }
}
