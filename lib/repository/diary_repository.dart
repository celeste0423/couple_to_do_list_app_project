import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/features/home/controller/diary_page_controller.dart';
import 'package:couple_to_do_list_app/helper/show_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/bukkung_list_model.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:couple_to_do_list_app/models/group_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiaryRepository {
  final GroupModel groupModel;

  DiaryRepository({required this.groupModel});

  Stream<List<DiaryModel>> getallDiary() {
    return FirebaseFirestore.instance.collection('groups')
        .doc(groupModel.uid)
        .collection('diary').orderBy('date', descending: true).
    snapshots().map((event) {
      List<DiaryModel> DiaryList = [];
      for (var Diary in event.docs) {
        DiaryList.add(DiaryModel.fromJson(Diary.data()));
      }
      return DiaryList;
    });
  }

  
  static Future<void> setGroupDiary(
      DiaryModel diaryData, String diaryId) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.user.value.groupId)
        .collection('diary')
        .doc(diaryId)
        .set(diaryData.toJson());
  }


  // static Future<void> setSuggestionBukkungList(BukkungListModel bukkungLisData,
  //     String listId) async {
  //   await FirebaseFirestore.instance
  //       .collection('bukkungLists')
  //       .doc(listId)
  //       .set(bukkungLisData.toJson());
  // }
  //
  // static Future<void> setGroupBukkungList(BukkungListModel bukkungLisData,
  //     String listId) async {
  //   await FirebaseFirestore.instance
  //       .collection('groups')
  //       .doc(AuthController.to.user.value.groupId)
  //       .collection('bukkungLists')
  //       .doc(listId)
  //       .set(bukkungLisData.toJson());
  // }
  //
  // Future<void> deleteListImage(String imagePath) async {
  //   try {
  //     Reference imageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('group_bukkunglist')
  //         .child('${AuthController.to.user.value.groupId}/$imagePath');
  //
  //     await imageRef.delete();
  //   } catch (e) {
  //     openAlertDialog(title: '이미지 삭제 오류 $e');
  //   }
  // }
}
