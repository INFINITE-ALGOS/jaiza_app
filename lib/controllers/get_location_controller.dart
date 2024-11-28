import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../provider/myprofile_controller.dart';

class GetLocationController{


  Future<Position?> checkAndRequestLocation() async {
    // Check for permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // If permission is still denied, inform the user
        return Future.error('Location permission is denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Send the user to settings
      await Geolocator.openAppSettings();
      return null;
    }

    // If permission granted, get the location
    return await Geolocator.getCurrentPosition();
  }
  Future<void> storeUserLocation(Position position,BuildContext context) async {
    String userLocation='';

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      // Format the address to display the exact area
      userLocation = "${place.street}, ${place.subLocality}, ${place.locality}, "
          "${place.administrativeArea}, ${place.country}";
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await Provider.of<MyProfileProvider>(context,listen: false).updateProfileData({
      'address': userLocation,
      'location': {'longitude': position.longitude, 'latitude': position.latitude}
    });
  }

}