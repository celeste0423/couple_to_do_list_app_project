import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CustomCachedNetworkImage(String imageurl, BoxFit? boxfit) {
  return CachedNetworkImage(
    fit: boxfit,
    imageUrl: imageurl,
    errorWidget: (context, url, error) => Image.asset('assets/images/baseimage_ggomool.png'),
  );
}
