import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: MaterialButton(
        onPressed: press(),
        child: Container(
          decoration: BoxDecoration(color: kPrimaryColor,border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
            borderRadius: BorderRadius.circular(2),
          ),
          width: SizeConfig.screenWidth,
          height: 50.0,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
