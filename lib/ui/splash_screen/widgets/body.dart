import 'package:flutter/material.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:lottie/lottie.dart';

import 'package:id_driver/core/constants/size_config.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<Body> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: getProportionateScreenHeight(165),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Indian Driver',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\n (Driver)',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 13)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
