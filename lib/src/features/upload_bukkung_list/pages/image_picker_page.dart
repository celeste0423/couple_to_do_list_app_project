// import 'dart:typed_data';
//
// import 'package:couple_to_do_list_app/utils/custom_color.dart';
// import 'package:couple_to_do_list_app/widgets/title_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:photo_manager/photo_manager.dart';
//
// class ImagePickerPage extends StatefulWidget {
//   const ImagePickerPage({Key? key}) : super(key: key);
//
//   @override
//   State<ImagePickerPage> createState() => _ImagePickerPageState();
// }
//
// class _ImagePickerPageState extends State<ImagePickerPage> {
//   List<Widget> imageList = [];
//   int currentPage = 0;
//   int? lastPage;
//
//   handleScrollEvent(ScrollNotification scroll) {
//     if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
//     //.metrics.pixels는 현재 스크롤 위치를 의미
//     //.metrics.maxScrollExtent 는 최대 스크롤 가능 범위 의미,
//     //따라서 현재 스크롤 위치가 전체 스크롤 위치의 33프로를 넘었을 때 fetchAllImages()실행
//     if (currentPage == lastPage) return;
//     // fetchAllImages();
//   }
//
//   // fetchAllImages() async {
//   //   //이미지 가지고 오기
//   //   lastPage = currentPage; //이미지가 더 없을 경우를 대비해 항상 마지막 페이지로 설정
//   //   // -------------권한 설정----------------------------------------------------
//   //   final permission = await PhotoManager.requestPermissionExtend(); //권한 요청
//   //   if (!permission.isAuth) return PhotoManager.openSetting(); //권한 없으면 설정창
//   //   //--------------사진 리스트 제작-----------------------------------------------
//   //   List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//   //     type: RequestType.image, //이미지만을 가져오도록
//   //     onlyAll: true, //전체 이미지를 다 가져올 수 있도록
//   //   );
//   //   List<AssetEntity> photos = await albums[0].getAssetListPaged(
//   //     //getAssetListPaged는 이미지를 페이지로 가져올 때 사용
//   //     //첫번째 앨범에서 페이징해서 사진 불러옴
//   //     page: currentPage,
//   //     size: 24,
//   //   );
//   //   List<Widget> temp = [];
//   //   //--------------리스트에 사진 FutureBuilder로 불러오기--------------------------
//   //   for (var asset in photos) {
//   //     //photos 리스트에서 하나씩 꺼내서 asset에 할당함
//   //     temp.add(
//   //       FutureBuilder(
//   //         future: asset.thumbnailDataWithSize(
//   //           const ThumbnailSize(200, 200),
//   //         ),
//   //         builder: (context, snapshot) {
//   //           if (snapshot.connectionState == ConnectionState.done) {
//   //             //snapshot의 connetctionState의 상태는 FutureBuilder에 정의돼있음
//   //             return ClipRRect(
//   //               borderRadius: BorderRadius.circular(5),
//   //               child: InkWell(
//   //                 onTap: () => Navigator.pop(context, snapshot.data),
//   //                 borderRadius: BorderRadius.circular(5),
//   //                 splashFactory: NoSplash.splashFactory,
//   //                 child: Container(
//   //                   margin: const EdgeInsets.all(2),
//   //                   decoration: BoxDecoration(
//   //                     border: Border.all(
//   //                       color: CustomColors.lightGrey.withOpacity(0.4),
//   //                       width: 1,
//   //                     ),
//   //                     image: DecorationImage(
//   //                       image: MemoryImage(snapshot.data as Uint8List),
//   //                       fit: BoxFit.cover,
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ),
//   //             );
//   //           }
//   //           return const Center(child: CircularProgressIndicator());
//   //         },
//   //       ),
//   //     );
//   //   }
//   //   setState(() {
//   //     imageList.addAll(temp);
//   //     //실제 출력을 위한 imageList에 temp의 위젯값을 다 더해줌
//   //     currentPage++;
//   //   });
//   // }
//
//   @override
//   void initState() {
//     // fetchAllImages();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: Get.back,
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: CustomColors.mainPink,
//             size: 35,
//           ),
//         ),
//         title: TitleText(
//           text: '갤러리',
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(5),
//         child: NotificationListener<ScrollNotification>(
//           //child의 notification을 감지, 콜백 함수 실현
//           onNotification: (ScrollNotification scroll) {
//             handleScrollEvent(scroll);
//             return true; //자식 위젯에서 이어서 이벤트 처리 가능
//           },
//           child: GridView.builder(
//             itemCount: imageList.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3),
//             itemBuilder: (_, index) {
//               return imageList[index];
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
