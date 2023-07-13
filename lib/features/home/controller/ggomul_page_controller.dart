import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/constants/constants.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:couple_to_do_list_app/repository/bukkung_list_repository.dart';
import 'package:couple_to_do_list_app/repository/list_completed_repository.dart';
import 'package:get/get.dart';

class GgomulPageController extends GetxController {
  Stream<List<BukkungListModel>> getAllCompletedList() {
    return ListCompletedRepository().getCompletedBukkungListByDate();
  }

  //리스트 삭제 기능을 제공해..? 말아
  void deleteCompletedList(BukkungListModel bukkungListModel) async {
    final GroupModel groupModel = AuthController.to.group.value;
    if (Constants.baseImageUrl != bukkungListModel.imgUrl) {
      await BukkungListRepository(groupModel: groupModel)
          .deleteListImage('${bukkungListModel.imgId}.jpg');
    }
    FirebaseFirestore.instance
        .collection('groups')
        .doc('${AuthController.to.user.value.groupId}')
        .collection('completedBukkungLists')
        .doc('${bukkungListModel.listId}')
        .delete();
  }
}
