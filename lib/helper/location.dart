import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtil {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text("Location Disabled"),
      //         content: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Text("Your location is disabled,please enable to use the app")
      //           ],
      //         ),
      //         actions: [
      //           TextButton(
      //               onPressed: () {
      //                 Navigator.pop(context);

      //                 Geolocator.openLocationSettings();
      //               },
      //               child: const Text("Okay"))
      //         ],
      //       );
      //     });

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text("Location Permission Require!"),
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: const [
        //             Text("Location permission is require to use the app")
        //           ],
        //         ),
        //         actions: [
        //           TextButton(
        //               onPressed: () async {
        //                 Navigator.pop(context);

        //                 permission = await Geolocator.requestPermission();
        //               },
        //               child: const Text("Okay"))
        //         ],
        //       );
        //     });

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
