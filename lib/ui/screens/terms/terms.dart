import 'package:flutter/material.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';

class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        title: const Text("Terms"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(50.0),
            ),
            Container(
              decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(getProportionateScreenHeight(50.0))),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(0.5, 1))
                  ]),
              child: Image.asset(
                "assets/images/logo.png",
                height: getProportionateScreenHeight(100.0),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30.0),
            ),
            Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 1))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "* I will greet to customer with the words Good morning or hello in the morning. I will not start or stop the mobile application without the customer consent.\n\n*Do not use a customer vehicle for self-use, and for any reason I do not request a customer to pick-up or drop-off a vehicle.\n\n*If needed I will request the customer to use the charger in their car. \n\n*I will probably use my own charger and power bank.\n\n*I will not operate on AC or radio without the customer permission\n\n* I will not interfere of talk about anything personal with client.\n\n*If for any reason I have to leave the car, I will not go without the consent of the customer and if I want to have a meal in the car, I will get their permission first.\n\n*Before boarding the car, I will inspect the vehicle thoroughly, if there is any injury to the car already, I will give it back to the customer.\n\n*If you drive without a seat belt, action will be taken and the person with the seat belt will be requested.\n\n* All traffic rules must be followed by the driver.\n\n* Driving at speed limit.\n\n* I will not discuss irrelevant things with the customer.\n\n* Strict action will be taken if the vehicle is used for personal work.\n\n* Do not sit in the car and eat the food (with the glass down) and not to damage the car and wipe the car with glass before sitting in the car.\n\n* If you are late for any reason then call Indian Driver and inform him.\n\n* If you need to argue with the owner for any reason, you should contact Indian drivers.\n\n* The car should not be left in the parking lot.\n\n* If any addiction is found while at work, strict action will be taken and no salary will be paid on that day.\n\n* Tell the owner if there is any injury to the vehicle.\n\n* Do not talk on mobile while driving.\n\n* If childrens and elderly person in the car, should open the door and help them sit in the car.\n\n* Driver should get dressed and shaved.\n\n* In case of accident or natural death Indian drivers or customer will not be resposible. We will claim the insurance company.\n\n* Once you accepted the duty and cancelled the same on duty start time then 200 RS/- will be deducted from the wallet and if this repeated 3 times then you will never get a trip again.\n\n* If you want to cancel the trip you should inform office 4 Hrs before start of the trip.\n\n* Drivers must carry the original license while on duty, if not with the original, the mobile application will be closed permanently.\n\n* Calling a customer before going on a duty only if there is a cancellation on time, no compensation will be paid.\n\n* While on duty, the charger and the power bank must be accompanied and the internet turned on.\n\n* Mobile Application requires Police Verification Certificate.\n\n* I will accept the bill from customer as per convience of him.\n\n* If you have any complaint about the customer 020-67641000 please call Indian Drivers office.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30.0),
            ),
          ],
        ),
      ),
    );
  }
}
