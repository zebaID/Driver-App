import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:id_driver/ui/screens/job_portal/job_portal.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomDrawerState();
  }
}

class _CustomDrawerState extends State<CustomDrawer> {
  var _name = "";
  var _mobile = "";
  var _email = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   void clearSession() async {
//     final SharedPreferences prefs = await _prefs;
//
//     prefs.clear();
//
// _finishAccountCreation();
//
//   }
//   void _finishAccountCreation() {
//     Navigator.pushAndRemoveUntil<void>(
//       context,
//       MaterialPageRoute<void>(builder: (BuildContext context) => SignInScreen()),
//       ModalRoute.withName('/'),
//     );
//   }

  // late final List<ListItem> items;

  List<ListItem> items =
      List<ListItem>.generate(1000, (i) => HeadingItem('Heading $i'));

  Future<void> _getSessionData() async {
    final SharedPreferences prefs = await _prefs;
    bool? isLogin = prefs.getBool("isLoggedIn");
    String? userDetails = prefs.getString("customerDetails");

    print("userDetails $userDetails");

    if (isLogin!) {
      final user = jsonDecode(userDetails!);
      setState(() {
        _name = user[0]['conUsers']['firstName'] +
            " " +
            user[0]['conUsers']['lastName'];
        _mobile = user[0]['conUsers']['mobileNumber'];
        _email = user[0]['conUsers']['email'];
      });
    }
  }

  @override
  void initState() {
    _getSessionData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: getProportionateScreenHeight(30),
                  child: Image.asset("assets/images/logo.png"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            _name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            _mobile,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(4.0),
                        //   child: Text(
                        //     _email,
                        //     style: const TextStyle(
                        //         color: Colors.white, fontSize: 13),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // ListView.builder(
          //   // Let the ListView know how many items it needs to build.
          //   itemCount: items.length,
          //   // Provide a builder function. This is where the magic happens.
          //   // Convert each item into a widget based on the type of item it is.
          //   itemBuilder: (context, index) {
          //     final item = items[index];
          //
          //     return ListTile(
          //       title: item.buildTitle(context),
          //       subtitle: item.buildSubtitle(context),
          //     );
          //   },
          // ),

          ListTile(
            title: Row(
              children: const [
                Icon(Icons.person_sharp, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.profile);
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.list_alt, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Trip History',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.mybooking);
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.wallet, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Wallet',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.wallet);
            },
          ),
          // ListTile(
          //   title: Row(
          //     children: const [
          //       Icon(
          //         Icons.work,
          //         color: Colors.grey,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 8.0),
          //         child: Text(
          //           'Job Portal',
          //           style: TextStyle(
          //               color: kTextBlackColor, fontWeight: FontWeight.normal),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //     //Navigator.pop(context);

          //     Navigator.pushNamed(context, AppRouter.jobPortal);
          //   },
          // ),

          // ListTile(
          //   title: Row(
          //     children: const [
          //       Icon(
          //         Icons.quiz,
          //         color: Colors.grey,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: 8.0),
          //         child: Text(
          //           'Online Test',
          //           style: TextStyle(
          //               color: kTextBlackColor, fontWeight: FontWeight.normal),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //     //Navigator.pop(context);

          //     Navigator.pushNamed(context, AppRouter.onlineTest);
          //   },
          // ),

          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.map_sharp,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Local Map',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.localMap);
            },
          ),

          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.newspaper,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'News',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.news);
            },
          ),

          ListTile(
            title: Row(
              children: const [
                Icon(Icons.currency_rupee, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Rate Card',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.ratecard);
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.featured_play_list, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Terms',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.terms);
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(Icons.contact_phone_rounded, color: Colors.grey),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                        color: kTextBlackColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            onTap: () {
              // Update the state of the app.
              // ...
              //Navigator.pop(context);

              Navigator.pushNamed(context, AppRouter.contactUs);
            },
          ),
          // ListTile(
          //   title: Row(
          //     children: const [
          //       Icon(Icons.exit_to_app, color: Colors.grey),
          //       Padding(
          //         padding: EdgeInsets.only(left: 8.0),
          //         child: Text(
          //           'Logout',
          //           style: TextStyle(
          //               color: kTextBlackColor, fontWeight: FontWeight.normal),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     // Navigator.of(context).pushNamed(AppRouter.availability);

          //     clearSession();
          //     // Update the state of the app.
          //     // ...
          //     //Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }

  void clearSession() async {
    final SharedPreferences prefs = await _prefs;

    prefs.clear();

    _finishAccountCreation();
  }

  void _finishAccountCreation() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const SignIn()),
      ModalRoute.withName('/'),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/ic_logout.png",
          height: 25,
          width: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(heading),
        ),
      ],
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}
