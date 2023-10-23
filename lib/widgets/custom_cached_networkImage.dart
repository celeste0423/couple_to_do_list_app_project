import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CustomCachedNetworkImage(String imageurl) {
  List<String> falsebaseimageurls = [
    '',
    'https://firebasestorage.googleapis.com/v0/b/bukkunglist.appspot.com/o/custom_app_image%2Fbukkung_list_icon.png?alt=media&token=977a5b74-602e-458b-b009-3554ac568acc',
    "https://firebasestorage.googleapis.com/v0/b/bukkunglist.appspot.com/o/custom_app_image%2F%EB%B0%B0%EA%B2%BD(%ED%9D%B0%EC%83%89)%EA%B3%A0%ED%99%94%EC%A7%88%20%EA%BC%AC%EB%AC%BC%EC%9D%B4.png?alt=media&token=56d2a70a-b20d-4b48-8edc-55aecc4f1237",
    "https://firebasestorage.googleapis.com/v0/b/bukkunglist.appspot.com/o/bukkung_list%2F67b9ade0-ee36-11ed-b243-2f79762c93de%2FClosure%3A%20(%7BMap%3CString%2C%20dynamic%3E%3F%20options%7D)%20%3D%3E%20String%20from%20Function%20'v4'%3A..jpg?alt=media&token=f8db7acb-8888-4ca6-97f9-0a6ab237055d"
  ];
  if (falsebaseimageurls.contains(imageurl)) {
    return AssetImage('assets/images/baseimage_ggomool.png');
  } else {
    print('notbaseimage');
    return CachedNetworkImageProvider(
      imageurl,
    );
  }
}

//errorBuilder:
//         (BuildContext context, Object exception, StackTrace? stackTrace) {
//       // Appropriate logging or analytics, e.g. log the exception.toString()
//       print('An error occurred loading "imageUrl": $exception');
//
//       // Return an image widget here
//       return Image.asset('assets/images/baseimage_ggomool.png');
//     },
