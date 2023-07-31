import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_to_do_list_app/features/admin_management/pages/admin_list_suggestion_page.dart';
import 'package:couple_to_do_list_app/helper/open_alert_dialog.dart';
import 'package:couple_to_do_list_app/repository/user_repository.dart';
import 'package:couple_to_do_list_app/widgets/main_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  Future updateImageUrl() async {
    CollectionReference fireStorecollection =
        FirebaseFirestore.instance.collection('bukkungLists');
    final storageRef = FirebaseStorage.instance.ref();

    for (int i = 1; i <= 150; i++) {
      String paddedIndex = i.toString().padLeft(3, '0');
      String docName = 'defaultBukkungList' + i.toString().padLeft(3, '0');

      String imageUrl; // Declare imageUrl outside the first try block

      try {
        imageUrl = await storageRef
            .child("suggestion_bukkunglist/$docName.jpg")
            .getDownloadURL();
      } catch (e) {
        // Handle the exception here (e.g., print a specific error message)
        print("Error fetching download URL for $paddedIndex: $e");
        break;
        // Alternatively, if you want to stop the loop immediately after the first exception,
        // you can use 'return;' instead of 'break;'.
      }

      // Move the second try block inside the first try block's scope
      try {
        await fireStorecollection.doc(docName).set({'imgUrl': imageUrl});
        print("URL for $docName uploaded successfully.");
      } catch (e) {
        print("Error updating Firestore document for $docName: $e");
      }
    }
  }

  Future uploadBukkungListWeb() async {
    const webAppUrl =
        'https://script.google.com/macros/s/AKfycbyhNL44tfuaZgH9EZHDLrVNhWZMAlQA6hGXDBp3F-PvaQ4EqvlfqJMLUAHL3Ws2ILFm/exec';
    final Uri url = Uri.parse(webAppUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch webapp : url = $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 페이지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              MainButton(
                buttonText: '기본버꿍리스트 업로드',
                buttonColor: Colors.grey,
                onTap: uploadBukkungListWeb
              ),
              MainButton(
                buttonText: '사진 URL: Storage->FireStore',
                buttonColor: Colors.grey,
                onTap: () async {
                  await updateImageUrl();
                  openAlertDialog(title: '이미지 url 업데이트 완료');
                },
              ),
              MainButton(
                buttonText: '추천 버꿍리스트 페이지',
                buttonColor: Colors.grey,
                onTap: () {
                  Get.to(() => AdminListSuggestionPage());
                },
              ),
              MainButton(
                buttonText: '로그아웃',
                buttonColor: Colors.red,
                onTap: () async {
                  await UserRepository.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
