import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/auth/controller/auth_controller.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/models/diary_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiaryRepository {
  final firestore = FirebaseFirestore.instance;

  DiaryRepository();

  Stream<List<DiaryModel>> getAllDiary() {
    return firestore
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('diary')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      List<DiaryModel> diaryList = [];
      for (var diary in event.docs) {
        diaryList.add(
          DiaryModel.fromJson(diary.data()),
        );
      }
      print('리스트 다 가져옴(dia repo)${diaryList.length}개');
      return diaryList;
    });
  }

  Stream<List<DiaryModel>> getCategoryDiary(String category) {
    return firestore
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('diary')
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      List<DiaryModel> diaryList = [];
      for (var diary in event.docs) {
        diaryList.add(
          DiaryModel.fromJson(
            diary.data(),
          ),
        );
      }
      return diaryList;
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

  Future<void> deleteDiary(String diaryId) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(AuthController.to.group.value.uid)
        .collection('diary')
        .doc(diaryId)
        .delete();
  }

  Future<void> deleteDiaryImage(String imgUrl) async {
    String filePath = FirebaseStorage.instance.refFromURL(imgUrl).fullPath;
    try {
      Reference imageRef = FirebaseStorage.instance.ref(filePath);
      await imageRef.delete();
    } catch (e) {
      openAlertDialog(title: '이미지 삭제 오류 $e');
    }
  }
}
