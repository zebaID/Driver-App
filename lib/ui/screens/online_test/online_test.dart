import 'package:flutter/material.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';

class OnlineTest extends StatelessWidget {
  const OnlineTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Test"),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(10.0),
          ),
          Text(
            "Question 1/20",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10.0),
          ),
          Text(
            "Q1. Which of the following economics activities belong to secondary sector",
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          GestureDetector(
            onTap: () {},
            child: InkWell(
              splashColor: Colors.white,
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Banking"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          GestureDetector(
            onTap: () {},
            child: InkWell(
              splashColor: Colors.white,
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Fishing"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Industries"),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          GestureDetector(
            onTap: () {},
            child: InkWell(
              splashColor: Colors.white,
              child: Container(
                width: SizeConfig.screenWidth * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Cattle Rearing"),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: InkWell(
                  splashColor: Colors.white,
                  child: Container(
                    width: SizeConfig.screenWidth / 2,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.grey),
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "Previous",
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: InkWell(
                  splashColor: Colors.white,
                  child: Container(
                    width: SizeConfig.screenWidth / 2,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.green),
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
