// import 'dart:convert';
//
// import 'package:couple_to_do_list_app/features/upload_bukkung_list/models/auto_complete_prediction.dart';
//
// class PlaceAutoCompleteResponse {
//   final String? status;
//   final List<AutoCompletePrediction>? predictions;
//
//   PlaceAutoCompleteResponse({this.status, this.predictions});
//
//   factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
//     return PlaceAutoCompleteResponse(
//       status: json['status'] as String?,
//       predictions: json['predictions'] != null
//           ? json['predictions']
//               .map<AutoCompletePrediction>(
//                   (json) => AutoCompletePrediction.fromJson(json))
//               .toList()
//           : null,
//     );
//   }
//
//   static PlaceAutoCompleteResponse parseAutocompleteResult(
//       String responseBody) {
//     final parsed = json.decode(responseBody).cast<String, dynamic>();
//
//     return PlaceAutoCompleteResponse.fromJson(parsed);
//   }
// }
