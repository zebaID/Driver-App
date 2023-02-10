import 'package:id_driver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomAppBarState();
  }
}

class _CustomAppBarState extends State<AppBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top - 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                iconSize: 24.0,
                icon: Image.asset(
                  "assets/images/menu.png",
                  scale: 20.0,
                ),
                onPressed: () => {},
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple, kPrimaryColor]),
          // boxShadow: [
          //   new BoxShadow(
          //     color: Colors.grey,
          //     blurRadius: 20.0,
          //     spreadRadius: 1.0,
          //   )
          // ]
        ),
      ),
      preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
    );
  }
}
