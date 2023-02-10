import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/logic/wallet/model/wallet_response_model.dart';
import 'package:id_driver/logic/wallet/wallet_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String result = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int amount = 500;
  List<int> amountList = [500, 600, 700, 800, 900, 1000, 2000];

  int transmissionType = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    context.read<WalletBloc>().add(GetWallet());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              radius: getProportionateScreenHeight(20),
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.25,
                width: SizeConfig.screenWidth,
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        // bottom: 10.0,
                        // right: 0.0,
                        // left: 0.0,
                        top: getProportionateScreenHeight(56),
                        child: SizedBox(
                          height: 280,
                          width: 280,
                          child: CustomPaint(
                            // size: Size(300, 300),
                            painter: MyPainter(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height: getProportionateScreenHeight(10.0),
                                // ),
                                const Text(
                                  "Available Balance",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10.0),
                                ),
                                Text(
                                  "₹ ${state.driverAccount.isNotEmpty ? state.driverAccount[0].balance : 00}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10.0),
                                ),

                                state.status.isSubmissionInProgress
                                    ? const CircularProgressIndicator()
                                    : OutlinedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: ((context) {
                                                return StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter
                                                          setState /*You can rename this!*/) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "Select Amount",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: amountList
                                                              .map((item) {
                                                            return Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        amount =
                                                                            item;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color:
                                                                                  kPrimaryColor),
                                                                          borderRadius:
                                                                              BorderRadius.circular(15)),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                            "₹ $item"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }).toList(),
                                                        ),
                                                        // Row(
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceEvenly,
                                                        //   children: [
                                                        //     InkWell(
                                                        //       onTap: () {
                                                        //         setState(() {
                                                        //           amount =
                                                        //               100;
                                                        //         });
                                                        //       },
                                                        //       child:
                                                        //           Container(
                                                        //         decoration: BoxDecoration(
                                                        //             border: Border.all(
                                                        //                 color:
                                                        //                     kPrimaryColor),
                                                        //             borderRadius:
                                                        //                 BorderRadius.circular(
                                                        //                     15)),
                                                        //         child:
                                                        //             const Padding(
                                                        //           padding:
                                                        //               EdgeInsets.all(
                                                        //                   8.0),
                                                        //           child: Text(
                                                        //               "₹ +100"),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //     InkWell(
                                                        //       onTap: () {
                                                        //         setState(() {
                                                        //           amount =
                                                        //               200;
                                                        //         });
                                                        //       },
                                                        //       child:
                                                        //           Container(
                                                        //         decoration: BoxDecoration(
                                                        //             border: Border.all(
                                                        //                 color:
                                                        //                     kPrimaryColor),
                                                        //             borderRadius:
                                                        //                 BorderRadius.circular(
                                                        //                     15)),
                                                        //         child:
                                                        //             const Padding(
                                                        //           padding:
                                                        //               EdgeInsets.all(
                                                        //                   8.0),
                                                        //           child: Text(
                                                        //               "₹ +200"),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //     InkWell(
                                                        //       onTap: () {
                                                        //         setState(() {
                                                        //           amount =
                                                        //               500;
                                                        //         });
                                                        //       },
                                                        //       child:
                                                        //           Container(
                                                        //         decoration: BoxDecoration(
                                                        //             border: Border.all(
                                                        //                 color:
                                                        //                     kPrimaryColor),
                                                        //             borderRadius:
                                                        //                 BorderRadius.circular(
                                                        //                     15)),
                                                        //         child:
                                                        //             const Padding(
                                                        //           padding:
                                                        //               EdgeInsets.all(
                                                        //                   8.0),
                                                        //           child: Text(
                                                        //               "₹ +500"),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //     InkWell(
                                                        //       onTap: () {
                                                        //         setState(() {
                                                        //           amount =
                                                        //               1000;
                                                        //         });
                                                        //       },
                                                        //       child:
                                                        //           Container(
                                                        //         decoration: BoxDecoration(
                                                        //             border: Border.all(
                                                        //                 color:
                                                        //                     kPrimaryColor),
                                                        //             borderRadius:
                                                        //                 BorderRadius.circular(
                                                        //                     15)),
                                                        //         child:
                                                        //             const Padding(
                                                        //           padding:
                                                        //               EdgeInsets.all(
                                                        //                   8.0),
                                                        //           child: Text(
                                                        //               "₹ +1000"),
                                                        //         ),
                                                        //       ),
                                                        //     )
                                                        //   ],
                                                        // ),
                                                        SizedBox(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  20),
                                                        ),
                                                        OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              side: const BorderSide(
                                                                  width: 1.0,
                                                                  color:
                                                                      kPrimaryColor),
                                                            ),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      WalletBloc>()
                                                                  .add(AddMoney(
                                                                      amount:
                                                                          amount));

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                                "₹ Add $amount")),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                amount = 500;
                                                              });
                                                            },
                                                            child: const Text(
                                                              "Reset",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                            ))
                                                      ],
                                                    );
                                                  },
                                                );
                                              }));
                                        },
                                        child: const Text(
                                          "Add Money",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                            side: MaterialStateProperty.all(
                                                const BorderSide(
                                                    color: Colors.white,
                                                    width: 1.0,
                                                    style: BorderStyle.solid))),
                                      ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              state.status.isSubmissionInProgress
                  ? const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          context.read<WalletBloc>().add(GetWallet());
                        },
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            WalletResponseModel walletResponseModel =
                                state.response[index];
                            return PaymentListItem(
                              isCredited: walletResponseModel.amount! > 0
                                  ? true
                                  : false,
                              amount: walletResponseModel.amount.toString(),
                              balance: walletResponseModel.balance.toString(),
                              date: DateFormat('dd-MM-yyyy hh:mm aa').format(
                                DateTime.parse(
                                    walletResponseModel.createdDate!),
                              ),
                              walletResponseModel: walletResponseModel,
                            );
                          },
                          itemCount: state.response.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                        ),
                      ),
                    )
            ],
          );
        },
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black.withOpacity(0.2);
    // canvas.drawArc(
    //   Rect.fromCenter(
    //     center: Offset(size.height / 2, size.width / 2),
    //     height: size.height,
    //     width: size.width,
    //   ),
    //   pi,
    //   pi,
    //   false,
    //   paint,
    // );
    canvas.drawCircle(
      Offset(size.height / 2, 110.0),
      size.height / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class PaymentListItem extends StatelessWidget {
  bool isCredited = true;
  String amount;
  String balance;
  String date;

  WalletResponseModel walletResponseModel;
  PaymentListItem(
      {Key? key,
      required this.amount,
      required this.balance,
      required this.date,
      required bool this.isCredited,
      required this.walletResponseModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elvButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
      maximumSize: const Size.fromHeight(45.0),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                  color: Colors.grey.withOpacity(0.5))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth,
              // ignore: prefer_const_constructors
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: isCredited ? kPrimaryColor : Colors.red,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isCredited
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Credited",
                                style: TextStyle(color: kWhiteColor),
                              ),
                              Text(
                                "Balance:- ₹ ${double.parse(balance).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Debited",
                                style: TextStyle(color: kWhiteColor),
                              ),
                              Text(
                                "Balance:- ₹${double.parse(balance).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Icon(
                      //     Icons.currency_rupee,
                      //     color: Colors.grey,
                      //     size: 17,
                      //   ),
                      // ),
                      Text(
                        "₹ ${double.parse(amount).toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          date,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    walletResponseModel.description!,
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  )
                  // Divider(
                  //   color: Colors.grey,
                  //   height: 5.0,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
