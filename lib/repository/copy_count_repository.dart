import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/models/copy_count_model.dart';

class CopyCountRepository {
  CopyCountRepository();

  Future<void> uploadCopyCount(
    CopyCountModel copyCountData,
  ) async {
    bool isListCopied = false;
    List<CopyCountModel>? copyCountList =
        await getCopyCountByListId(copyCountData.listId!);
    copyCountList?.map((item) => {
          if (item.uid == copyCountData.uid) {isListCopied = true}
        });
    if (isListCopied) {
      CopyCountModel updatedCopyCountData = copyCountData.copyWith(
        createdAt: DateTime.now(),
      );
      updateCopyCount(updatedCopyCountData);
    } else {
      setCopyCount(copyCountData);
    }
  }

  Future<void> setCopyCount(
    CopyCountModel copyCountData,
  ) async {
    await FirebaseFirestore.instance
        .collection('copyCount')
        .doc(copyCountData.id)
        .set(copyCountData.toJson());
  }

  Future<void> updateCopyCount(
    CopyCountModel copyCountData,
  ) async {
    await FirebaseFirestore.instance
        .collection('copyCount')
        .doc(copyCountData.id)
        .update(copyCountData.toJson());
  }

  Future<void> deleteCopyCountByUid(String uid) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('copyCount')
          .where('uid', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 각 문서를 삭제합니다.
        await doc.reference.delete();
      }
    } catch (e) {
      print("copyCount 문서 삭제 오류: $e");
      throw e; // 오류를 처리하거나 다시 던질 수 있습니다.
    }
  }

  Future<void> deleteCopyCountByListId(String listId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('copyCount')
          .where('list_id', isEqualTo: listId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // 각 문서를 삭제합니다.
        await doc.reference.delete();
      }
    } catch (e) {
      print("copyCount 문서 삭제 오류: $e");
      throw e; // 오류를 처리하거나 다시 던질 수 있습니다.
    }
  }

  Future<List<CopyCountModel>?> getCopyCountByListId(String listId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('copyCount')
          .where('list_id', isEqualTo: listId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<CopyCountModel> result = querySnapshot.docs
            .map((doc) =>
                CopyCountModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        return result;
      } else {
        return null; // 데이터가 없는 경우 null 반환 또는 빈 리스트로 처리할 수 있습니다.
      }
    } catch (e) {
      print("copyCount 데이터 가져오기 오류: $e");
      return null;
    }
  }
}
