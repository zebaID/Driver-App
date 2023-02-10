import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:id_driver/ui/splash_screen/widgets/body.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/constants.dart';
import '../../data/repositories/AuthRepository.dart';

class SplashScreen extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SplashScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _getSessionData() async {
      final SharedPreferences prefs = await _prefs;
      bool? isLogin = prefs.getBool("isLoggedIn");
      // String? userDetails = prefs.getString("UserSession");
      if (isLogin != null && isLogin) {
        // Map<String, dynamic> user = jsonDecode(userDetails!);
        // UserModel userModel=UserModel.fromJson(user);
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const Dashboard()),
          ModalRoute.withName(AppRouter.dashboard),
        );
      } else {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const SignIn()),
          ModalRoute.withName(AppRouter.login),
        );
      }
    }

    void getVersion() async {
      String? version = await AuthRepository().getAppVersion();
      if (int.parse(kAppVersion) < int.parse(version!)) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  title: const Text("New Version Available"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                          "New version is available. Please update application to proceed.")
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          // DataProvider().clearSession(context);

                          _launchUrl(Platform.isAndroid
                              ? kPlayStoreUrl
                              : kAppStoreUrl);

                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                        child: const Text("Update"))
                  ],
                ),
              );
            });
      } else {
        _getSessionData();
      }
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      getVersion();
    });

    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => {
                    if (Platform.isAndroid)
                      {SystemNavigator.pop()}
                    else if (Platform.isIOS)
                      {exit(0)}
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return const Body();
  }
}
