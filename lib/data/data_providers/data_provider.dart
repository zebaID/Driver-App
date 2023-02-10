// Dummy file

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String?> getSessionData() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      return prefs.getString("customerDetails");
    }
    return null;
  }

  Future<String?> setSessionData() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      return prefs.getString("customerDetails");
    }
    return null;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? userSession = prefs.getString("UserSession");

      final parsed = jsonDecode(userSession!);
      return parsed['id'];
    }
    return null;
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? userSession = prefs.getString("UserSession");

      final parsed = jsonDecode(userSession!);
      return parsed['userId'].toString();
    }
    return null;
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? userSession = prefs.getString("customerDetails");

      final parsed = jsonDecode(userSession!);
      return parsed[0]['conUsers']['firstName'];
    }
    return null;
  }

  Future<String?> getUserMobile() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? userSession = prefs.getString("customerDetails");

      final parsed = jsonDecode(userSession!);
      return parsed[0]['conUsers']['mobileNumber'];
    }
    return null;
  }

  Future<String?> getCityId() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? cityData = prefs.getString("cityId");

      final parsed = jsonDecode(cityData!);
      return parsed['id'].toString();
    }
    return null;
  }

  Future<String?> getCityContactNumber() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? cityData = prefs.getString("cityId");

      final parsed = jsonDecode(cityData!);
      return parsed['contactNumber'].toString();
    }
    return null;
  }

  Future<String?> getCityName() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    if (isLogin!) {
      String? cityData = prefs.getString("customerDetails");

      final parsed = jsonDecode(cityData!);
      return parsed[0]['conUsers']['operationCity'];
    }
    return null;
  }

  void clearSession(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;

    prefs.clear();

    // _finishAccountCreation(context);
  }

  void _finishAccountCreation(BuildContext context) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const SignIn()),
      ModalRoute.withName('/'),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
