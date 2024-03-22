// import 'package:couple_to_do_list_app/features/read_bukkung_list/controller/read_completed_list_page_controller.dart';
// import 'package:couple_to_do_list_app/utils/category_to_text.dart';
// import 'package:couple_to_do_list_app/utils/custom_color.dart';
// import 'package:couple_to_do_list_app/widgets/category_icon.dart';
// import 'package:couple_to_do_list_app/widgets/custom_cached_networkImage.dart';
// import 'package:couple_to_do_list_app/widgets/png_icons.dart';
// import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
// import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
// import 'package:couple_to_do_list_app/widgets/title_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ReadCompletedListPage extends GetView<ReadCompletedListPageController> {
//   const ReadCompletedListPage({
//     Key? key,
//   }) : super(key: key);
//
//   PreferredSizeWidget _appBar() {
//     return AppBar(
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 10),
//         child: CupertinoButton(
//           onPressed: () {
//             Get.back();
//           },
//           padding: EdgeInsets.zero,
//           child: Icon(
//             Icons.arrow_back_ios,
//             size: 30,
//             color: CustomColors.grey,
//           ),
//         ),
//       ),
//       title: TitleText(
//         text: '상세보기',
//       ),
//     );
//   }
//
//   Widget _detailContent() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Row(
//                 children: [
//                   CategoryIcon(
//                     category: controller.bukkungListModel.category!,
//                     size: 35,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     CategoryToText(controller.bukkungListModel.category!),
//                     style: TextStyle(
//                       color: CustomColors.greyText,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: PcText(
//                         controller.bukkungListModel.title!,
//                         style: TextStyle(
//                           color: CustomColors.blackText,
//                           fontSize: 35,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 // Expanded(
//                 //   flex: 1,
//                 //   child: Padding(
//                 //     padding:
//                 //         const EdgeInsets.only(left: 10, right: 10, top: 10),
//                 //     child: FittedBox(
//                 //       fit: BoxFit.scaleDown,
//                 //       child: Text(
//                 //         controller.bukkungListModel.date!
//                 //             .toString()
//                 //             .substring(0, 10),
//                 //         style: TextStyle(
//                 //           color: CustomColors.greyText,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
//               child: Obx(
//                 () => Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image:
//                             CustomCachedNetworkImage(controller.imgUrl.value),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50),
//                       bottomLeft: Radius.circular(50),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       PngIcon(
//                         iconName: 'location-pin',
//                         iconSize: 35,
//                       ),
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: BkText(
//                           controller.bukkungListModel.location!,
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: CustomColors.blackText,
//                           ),
//                           softWrap: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(left: 10, right: 10, top: 10),
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: BkText(
//                         controller.bukkungListModel.date!
//                             .toString()
//                             .substring(0, 10),
//                         style: TextStyle(
//                           color: CustomColors.greyText,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: BkText(
//                   controller.bukkungListModel.content!,
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: CustomColors.blackText,
//                     height: 1.3,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget _bottomBar() {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//   //     child: GestureDetector(
//   //       onTap: () {
//   //         ListCompletedRepository.setCompletedBukkungList(
//   //             controller.bukkungListModel);
//   //         BukkungListPageController.to
//   //             .deleteBukkungList(controller.bukkungListModel);
//   //
//   //         DiaryModel diaryModel = DiaryModel.init(AuthController.to.user.value);
//   //         DiaryModel updatedDiaryModel = diaryModel.copyWith(
//   //           title: controller.bukkungListModel.title,
//   //           category: controller.bukkungListModel.category,
//   //           location: controller.bukkungListModel.location,
//   //           date: controller.bukkungListModel.date,
//   //           updatedAt: DateTime.now(),
//   //         );
//   //         Get.off(() => UploadDiaryPage(), arguments: updatedDiaryModel);
//   //       },
//   //       child: Container(
//   //         width: 140,
//   //         height: 50,
//   //         decoration: BoxDecoration(
//   //           borderRadius: BorderRadius.circular(25),
//   //           color: CustomColors.mainPink,
//   //         ),
//   //         child: Center(
//   //           child: Text(
//   //             '리스트 완료',
//   //             style: TextStyle(
//   //               color: Colors.white,
//   //               fontSize: 25,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(ReadCompletedListPageController());
//     return Scaffold(
//       appBar: _appBar(),
//       body: _detailContent(),
//       // bottomNavigationBar: _bottomBar(),
//     );
//   }
// }
