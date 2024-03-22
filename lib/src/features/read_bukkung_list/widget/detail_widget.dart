// import 'package:couple_to_do_list_app/utils/category_to_text.dart';
// import 'package:couple_to_do_list_app/utils/custom_color.dart';
// import 'package:couple_to_do_list_app/widgets/category_icon.dart';
// import 'package:couple_to_do_list_app/widgets/png_icons.dart';
// import 'package:couple_to_do_list_app/widgets/text/BkText.dart';
// import 'package:couple_to_do_list_app/widgets/text/PcText.dart';
// import 'package:flutter/material.dart';
//
// Widget _detailContent() {
//   return Padding(
//     padding: const EdgeInsets.only(left: 20),
//     child: SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Row(
//               children: [
//                 CategoryIcon(
//                   category: controller.bukkungListModel.category!,
//                   size: 35,
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   CategoryToText(controller.bukkungListModel.category!),
//                   style: TextStyle(
//                     color: CustomColors.greyText,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: PcText(
//                     controller.bukkungListModel.title!,
//                     style: TextStyle(
//                       color: CustomColors.blackText,
//                       fontSize: 35,
//                     ),
//                     softWrap: true,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 20),
//               // Expanded(
//               //   flex: 1,
//               //   child: Padding(
//               //     padding:
//               //         const EdgeInsets.only(left: 10, right: 10, top: 10),
//               //     child: FittedBox(
//               //       fit: BoxFit.scaleDown,
//               //       child: Text(
//               //         controller.bukkungListModel.date!
//               //             .toString()
//               //             .substring(0, 10),
//               //         style: TextStyle(
//               //           color: CustomColors.greyText,
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
//             child: Obx(
//                   () => Container(
//                 height: 250,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50),
//                     bottomLeft: Radius.circular(50),
//                   ),
//                   image: DecorationImage(
//                     image: NetworkImage(
//                       controller.imgUrl.value!,
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     PngIcon(
//                       iconName: 'location-pin',
//                       iconSize: 35,
//                     ),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: BkText(
//                         controller.bukkungListModel.location!,
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: CustomColors.blackText,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.only(left: 10, right: 10, top: 10),
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: BkText(
//                       controller.bukkungListModel.date!
//                           .toString()
//                           .substring(0, 10),
//                       style: TextStyle(
//                         color: CustomColors.greyText,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: BkText(
//                 controller.bukkungListModel.content!,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: CustomColors.blackText,
//                   height: 1.3,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
