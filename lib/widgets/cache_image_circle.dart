import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class CacheImageCircle extends StatelessWidget {
   final String url;
   final double radius;
   final double borderRadius;
  const CacheImageCircle({super.key,required this.url, this.borderRadius=17.5, this.radius=35});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius, // Increase the size to make the circular image more visible
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect( // Clip the image in a circular shape
        borderRadius: BorderRadius.circular(borderRadius), // Half of the width/height to make it circular
        child: CachedNetworkImage(
          imageUrl:
          url,
          fit: BoxFit.cover, // This will make sure the image covers the entire circular area
        ),
      ),
    );
  }
}
