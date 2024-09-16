import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> crouselUrls; // List of image URLs

  // Example list of URLs for testing purposes
  final List<String> testUrls = [
    'https://via.placeholder.com/400x200.png?text=Image1',
    'https://via.placeholder.com/400x200.png?text=Image2',
    'https://via.placeholder.com/400x200.png?text=Image3',
  ];

  ImageCarousel({required this.crouselUrls});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0, // Adjust the height for the image container
        enlargeCenterPage: true, // Center image is enlarged
        autoPlay: true, // Enable automatic sliding
        autoPlayInterval: Duration(seconds: 3), // Time interval between slides
        aspectRatio: 16 / 9, // Aspect ratio for the images
        viewportFraction: 0.8, // Fraction of the viewport each slide takes up
      ),
      items: crouselUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 5.0), // Margin for spacing between images
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    10.0), // Ensure images have rounded corners
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                    width: double.infinity,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  placeholder: (context, url) => ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),


                ),
                // Image.network(
                //   url,
                //   fit: BoxFit.cover, // Ensure the image covers the entire container
                //   width: double.infinity, // Make sure image width fills the container
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child; // Image fully loaded
                //     return Center(
                //       child: CircularProgressIndicator(), // Show loader while image loads
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return Center(child: Icon(Icons.error)); // Show error icon if the image fails
                //   },
                // )
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
