import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CachedPlaceholderImage extends StatelessWidget {
  const CachedPlaceholderImage(
      {Key? key, required this.imageUrl, this.fit = BoxFit.cover, this.height,this.width})
      : super(key: key);

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Image.asset(
        'assets/logo_scanningworld.png',
      ),
      errorWidget: (context, url, error) =>  Image.asset(
        'assets/logo_scanningworld.png',
      ),
      height: height,
      width: width,
      fit: fit,
    );
  }
}
