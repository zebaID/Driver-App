import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/size_config.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        title: const Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                          offset: const Offset(0.5, 1))
                    ]),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: getProportionateScreenHeight(100.0),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Indian Drivers",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Driving People",
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20.0),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 1))
                    ]),
                child: Column(
                  children: [
                    // const Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     "Hello!",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     "Welcome To The Best Deals On Driver Services In India.",
                    //     style: TextStyle(color: Colors.red.shade600),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Indian Driver (ID) is a unit of ID Car Driver Private Limited",
                        style: TextStyle(color: Colors.blueGrey.shade600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "We are a transportation technology company headquarted in Pune and Branch at Aurangabad. We have already proven our credibility into car driver management, serving this industry since 2009.",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            ),
                            TextSpan(
                              text:
                                  "\n\nOur technology service enable our customer a effortless driver hiring on temporary or permanent basis.",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            ),
                            TextSpan(
                              text:
                                  "\n\nWe are continually evolving out technical abilities to make driver hiring faster,easier and reliable.",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10.0),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 1))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Head Office",
                              style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            TextSpan(
                              text:
                                  "\n\nSukrut Apt, Opp Bharat Natya Mandir, Sadashiv Peth, Pune, Maharashtra-411030.",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10.0),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.9,
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 1))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Branches",
                              style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            TextSpan(
                              text:
                                  "\n\n1. Shop No.2, Deluxe Complex, Trimurti Chowk, Jawahar colony, Aurangabad-431009",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            ),
                            TextSpan(
                              text:
                                  "\n\n2. Shop No.5-8, Gods Gift Building, NM Joshi Marg, Railway colony, Lower Parel, Mumbai, Maharashtra-400013",
                              style: TextStyle(color: Colors.blueGrey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
