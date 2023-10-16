import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CustomCachedNetworkImage() {
  List<String> imgurlList = ['a', 'b'];
  for (String url in imgurlList) {}
  return CachedNetworkImage(
    imageUrl: '',
    errorWidget: (context, url, error) => Image.asset('assets/error_image.png'),
  );
}
