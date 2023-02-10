import 'dart:convert';
import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/core/global_widgets/text_field.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/booking/bloc/booking_bloc.dart';
import 'package:id_driver/logic/booking/model/booking_response_model.dart';
import 'package:id_driver/logic/booking/model/current_duty_response_model.dart';
import 'package:id_driver/logic/model/booking_model.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({Key? key}) : super(key: key);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails>
    with TickerProviderStateMixin {
  String city = 'Pune';
  String carType = 'Manual';
  String bookingType = 'Local';
  String tripType = 'Round Trip';
  // late final AnimationController _controller;

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  late TextEditingController _addresLine1;
  late TextEditingController _addresLine2;
  late TextEditingController _estHour;
  late TextEditingController _pickUpLocation;
  late TextEditingController _dropLocation;

  late TextEditingController _transmissionType;
  late TextEditingController _travelType;
  late TextEditingController _tripType;

  late TextEditingController _estMinute;
  late TextEditingController _promoCode;
  bool _isSelected = false;
  DateTime _relievingDateTime = DateTime.now();
  String _relvTime = DateFormat('hh:mm aa').format(DateTime.now());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _selectedIndex = 1;
  String _estimatedHours = "2";
  late String totalAmount = "";
  bool isReleivingSel = false;
  bool dutyStatus = false;

  Map<String, dynamic>? bookingDetails;

  @override
  void initState() {
    _addresLine1 = TextEditingController();
    _addresLine2 = TextEditingController();
    _estHour = TextEditingController();
    _estMinute = TextEditingController();
    _promoCode = TextEditingController();
    _pickUpLocation = TextEditingController();
    _dropLocation = TextEditingController();
    _transmissionType = TextEditingController();
    _tripType = TextEditingController();
    _travelType = TextEditingController();

    _dropLocation.text = "Mumbai";
    _pickUpLocation.text = "Pune";
    _transmissionType.text = "Manual";
    _travelType.text = "Local";
    _tripType.text = "Round Trip";
    _addresLine1.text = "Flat No 501";
    _addresLine2.text = "Magarpatta City";
    _estHour.text = "12";
    _estMinute.text = "00";
    // _controller = AnimationController(vsync: this);
    // _controller.repeat(
    //     reverse: true, period: Duration(milliseconds: (1 * 3000).round()));
    // _controller.addStatusListener((status) async {
    //   if (status == AnimationStatus.completed) {
    //     // Navigator.pop(context);
    //     _controller.reset();
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    _addresLine1.dispose();
    _addresLine2.dispose();
    _estHour.dispose();
    _estMinute.dispose();
    _promoCode.dispose();
    _pickUpLocation.dispose();
    _transmissionType.dispose();
    _travelType.dispose();
    _tripType.dispose();
    _dropLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    Map booking = ModalRoute.of(context)!.settings.arguments as Map;

    CurrentDutyResponseModel currentDutyResponseModel =
        booking['bookingResponseModel'];

    context
        .read<BookingBloc>()
        .add(GetBookingDetails(int.parse(currentDutyResponseModel.bookingId!)));

    // BookingModel bookingModel =
    //     ModalRoute.of(context)!.settings.arguments as BookingModel;
    // print(bookingModel.carType);

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: kPrimaryColor,
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
      maximumSize: const Size.fromHeight(45.0),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: const Text("Booking Details"),
        backgroundColor: kPrimaryColor,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          // double tAmount = 0.0;
          // final res = jsonDecode(state.response);
          // res.forEach((e) {
          //   print(e['amount']);
          //   tAmount = tAmount + e['amount'];
          // });
          // totalAmount = NumberFormat("###.0#").format(tAmount);
          print("Duty end Response ${state.response}");
          if (state.status.isSubmissionSuccess && state.response.isNotEmpty) {
            List<dynamic> resp = jsonDecode(state.response);

            try {
              resp.forEach((element) {
                Map<String, dynamic> j = element;
                if (j.containsKey('off_duty_for_driver')) {
                  if (j['off_duty_for_driver'] == "Done") {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text("Trip Already Ended.."),
                        backgroundColor: Colors.amber,
                      ));
                    // setState(() {
                    //   dutyStatus = true;
                    // });
                    // context.read<BookingBloc>().add(GetBookingDetails(
                    //     int.parse(currentDutyResponseModel.bookingId!)));
                  } else if (j['off_duty_for_driver'] == "Success") {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text("Trip Ended.."),
                        backgroundColor: Colors.amber,
                      ));
                    // setState(() {
                    //   dutyStatus = true;
                    // });
                    // context.read<BookingBloc>().add(GetBookingDetails(
                    //     int.parse(currentDutyResponseModel.bookingId!)));
                    // Navigator.pushAndRemoveUntil<void>(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //       builder: (BuildContext context) => const Dashboard()),
                    //   ModalRoute.withName(AppRouter.dashboard),
                    // );
                  }
                } else if (j.containsKey('paid_duty_function')) {
                  if (j['paid_duty_function'] == "Paid" ||
                      j['paid_duty_function'] == "0") {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text("Trip Ended Succesfully.."),
                        backgroundColor: Colors.green,
                      ));

                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Dashboard()),
                      ModalRoute.withName(AppRouter.dashboard),
                    );
                  }
                }
              });
            } catch (e) {
              print('element err $e');
            }
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state.status.isSubmissionSuccess &&
                state.bookingDetailsReponse.isNotEmpty) {
              bookingDetails = jsonDecode(state.bookingDetailsReponse);
            }
            if (state.status.isSubmissionInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (bookingDetails != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: getProportionateScreenHeight(20.0),
                      // ),
                      // AppTextField(
                      //     readOnly: true,
                      //     inputType: "text",
                      //     width: 0.9,
                      //     controller: _addresLine1,
                      //     labelText: "Pickup"),
                      SizedBox(
                        height: getProportionateScreenHeight(20.0),
                      ),
                      const Text(
                        "Booking Id",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        bookingDetails!['id'].toString(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10.0),
                      ),
                      const Text(
                        "Journey",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(5.0),
                      ),
                      const Text(
                        "Reporting Location",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          "${bookingDetails!['pickAddress']}",
                          textAlign: TextAlign.center,
                        ),
                      ),

                      bookingDetails!['isOutstation'] == true
                          ? Column(
                              children: [
                                const Icon(Icons.arrow_downward),
                                const Text(
                                  "Outstation Location",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    "${bookingDetails!['dropAddress']}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : bookingDetails!['isRoundTrip'] == false
                              ? Column(
                                  children: [
                                    const Icon(Icons.arrow_downward),
                                    const Text(
                                      "Drop Location",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        "${bookingDetails!['dropAddress']}",
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),

                      SizedBox(
                        height: getProportionateScreenHeight(10.0),
                      ),

                      SizedBox(
                        height: getProportionateScreenHeight(20.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Reporting Time",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Text(DateFormat('dd-MM-yyyy hh:mm aa').format(
                                  DateTime.parse(
                                          "${bookingDetails!['reportingDate'].toString().substring(0, 10)} ${bookingDetails!['reportingTime']}")
                                      .add(const Duration(days: 1)))),
                            ],
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                                child: Text(
                                  "Travel Type",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "${bookingDetails!['isRoundTrip'] == true ? "Round" : "One Way"} - "),
                                  Text(bookingDetails!['isOutstation'] == true
                                      ? "Outstation"
                                      : "Local"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(
                        width: getProportionateScreenWidth(5.0),
                      ),
                      // SizedBox(
                      //   height: getProportionateScreenHeight(20.0),
                      // ),

                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Text(
                          "Transmission",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),

                      Text(bookingDetails!['carType'] == 'M'
                          ? 'Manual'
                          : bookingDetails!['carType'] == 'A'
                              ? 'Automatic'
                              : 'Luxury'),

                      /*Releving Date Time*/
                      bookingDetails!['isOutstation'] == true
                          ? Column(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 5.0, top: 10.0),
                                  child: Text(
                                    "Relieving Time",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     color: Colors.grey.withOpacity(0.3),
                                  //     border: Border.all(
                                  //         color: Colors.green, width: 2),
                                  //     borderRadius: BorderRadius.circular(5.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(DateFormat(
                                            'dd-MM-yyyy hh:mm aa')
                                        .format(DateTime.parse(
                                                "${bookingDetails!['invoices'][0]['releavingDate'].toString().substring(0, 10)} ${bookingDetails!['invoices'][0]['releavingTime']}")
                                            .add(const Duration(days: 1)))),
                                  ),
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(20.0),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 5.0, top: 15.0),
                                  child: Text(
                                    "Estimated Duty Hours (HH:mm)",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                                Text(getTimeString(bookingDetails!['invoices']
                                            [0]['totalTravelTime'] ==
                                        null
                                    ? 0
                                    : bookingDetails!['invoices'][0]
                                        ['totalTravelTime']))
                              ],
                            ),

                      SizedBox(
                        height: getProportionateScreenHeight(20.0),
                      ),
                      BookingListItem(
                        context: context,
                        totalAmount: NumberFormat("###.0#").format(
                            bookingDetails!['idShare'] +
                                bookingDetails!['driverShare']),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AppRouter.ratecard);
                              },
                              child: const Text(
                                "Rate Card",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ),
                      ),

                      (state.currentDuty[0].status == "Done" ||
                                  state.currentDuty[0].status == "Paid") &&
                              state.currentDuty[0].tripType == "R"
                          ? ElevatedButton(
                              style: style,
                              onPressed: () {
                                // Navigator.of(context).pushNamed(
                                //     AppRouter.cancelBooking,
                                //     arguments: {"bookingId": booking['bookingId']});

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Confirmation"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                                "Are you sure you want to off the duty")
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                context.read<BookingBloc>().add(
                                                    OffDuty(
                                                        currentDutyResponseModel));
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Confirm"))
                                        ],
                                      );
                                    });
                              },
                              child: const Text('Off Duty'),
                            )
                          : state.currentDuty[0].status == "Done" ||
                                  state.currentDuty[0].status == "Paid" &&
                                      state.currentDuty[0].tripType != "R"
                              ? ElevatedButton(
                                  style: style,
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(
                                    //     AppRouter.cancelBooking,
                                    //     arguments: {"bookingId": booking['bookingId']});

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    "Are you sure you have accepted ${state.currentDuty[0].netAmount!.toStringAsFixed(2)} cash?  मी  ${state.currentDuty[0].netAmount!.toStringAsFixed(2)} कॅश घेतलेली आहे.")
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<BookingBloc>()
                                                        .add(AcceptCash(
                                                            currentDutyResponseModel));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Confirm"))
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('Accept Cash'),
                                )
                              : ElevatedButton(
                                  style: style,
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(
                                    //     AppRouter.cancelBooking,
                                    //     arguments: {"bookingId": booking['bookingId']});

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    "Are you sure you want to off the duty")
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<BookingBloc>()
                                                        .add(OffDuty(
                                                            currentDutyResponseModel));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Confirm"))
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('Off Duty'),
                                ),

                      SizedBox(
                        height: getProportionateScreenHeight(20.0),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        ),
      ),
    );
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  Future _showDatePicker(BuildContext context) async {
    final newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));

    if (newDate == null) return;

    setState(() {
      date = newDate;
    });
  }

  void _showCupertinoDatePicker(ctx, BookingModel bookingModel) {
    final minDate = DateTime.parse(bookingModel.reportingDate!);
    final difference = 30 - minDate.minute % 30;
    final initialDate = minDate.add(Duration(minutes: difference));

    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 300,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Select Releiving Time",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                        initialDateTime: initialDate,
                        minuteInterval: 15,
                        maximumDate: minDate.add(const Duration(days: 7)),
                        minimumDate: minDate,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _relievingDateTime = val;
                            _relvTime = DateFormat('hh:mm aa').format(val);
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        isReleivingSel = true;
                      });
                      context.read<BookingBloc>().add(CalculateFareSubmitted(
                          carType,
                          bookingModel.isRoundTrip!,
                          bookingModel.isOutstation!,
                          bookingModel.reportingDate!,
                          bookingModel.reportingTime!,
                          DateFormat('y-MM-dd').format(_relievingDateTime),
                          _relvTime,
                          bookingModel.pickupLat!,
                          bookingModel.pickupLng!,
                          bookingModel.dropLat!,
                          bookingModel.dropLng!,
                          "6"));
                    },
                  )
                ],
              ),
            ));
  }

  Future _showTimePicker(BuildContext context) async {
    final newTime = await showTimePicker(context: context, initialTime: time);

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });
  }

  Future<void> _showPaymentDialog(
      BuildContext context, String bookingId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Your Booking is successfully scheduled.',
                    style: const TextStyle(color: kBlackColor, fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Your Booking Id is $bookingId ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      // TextSpan(text: 'as per convenience of the driver!'),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10.0)),
                Lottie.asset('assets/animations/thumb_stars.json',
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(150)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Dashboard()),
                  ModalRoute.withName(AppRouter.dashboard),
                );
              },
            ),
            // TextButton(
            //   child: const Text('Proceed'),
            //   onPressed: () {
            //     Navigator.pop(context);

            //     // Navigator.pushNamed(context, AppRouter.confirmBooking);
            //   },
            // ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(BookingModel bookingModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                    text:
                        'We have taken utmost care while selecting driver,however we are not responsible fo any type of losses including financial with respect to services, Please check',
                    style: TextStyle(color: kBlackColor, fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Original Driving License ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'before handing over key to driver.'),
                      TextSpan(
                          text:
                              '\nNeed to make payment by cash immediately once trip is over.'),
                      TextSpan(
                          text:
                              '\nIf not agree with these terms, please cancel the booking.'),
                      TextSpan(text: '\nFor Queries call us on'),
                      TextSpan(
                          text: ' 020-67641000',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' or email us on '),
                      TextSpan(
                          text: "info@indian-driver.com",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              "\n\nNote :- If you travel beyond local boundries your fare will be updated ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10.0)),
                // Lottie.asset('assets/animations/thumb_stars.json',
                //     height: getProportionateScreenHeight(150),
                //     width: getProportionateScreenWidth(150),
                //     repeat: true
                //     // controller: _controller,
                //     // onLoaded: (composition) {
                //     //   // Configure the AnimationController with the duration of the
                //     //   // Lottie file and start the animation.
                //     //   _controller
                //     //     ..duration = composition.duration
                //     //     ..forward();
                //     // },
                //     )
                RichText(
                  text: const TextSpan(
                    text:
                        'Please note customer will have to pay billed amount to driver directly by ',
                    style: TextStyle(color: kBlackColor, fontSize: 13),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Cash,Paytm or IMPS ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'as per convenience of the driver!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Accept & Book'),
              onPressed: () {
                // final state = context.watch<BookingBloc>().state.response;
                // final decode=jsonDecode(state);

                context.read<BookingBloc>().add(BookingSubmit(
                    carType: carType,
                    isRoundTrip: bookingModel.isRoundTrip!,
                    isOutstation: bookingModel.isOutstation!,
                    reportingDate: bookingModel.reportingDate!,
                    reportingTime: bookingModel.reportingTime!,
                    releivingDate:
                        DateFormat('y-MM-dd').format(_relievingDateTime),
                    releivingTime: _relvTime,
                    releavingDuration: bookingModel.isOutstation == "true"
                        ? _relievingDateTime
                            .difference(DateTime.parse(bookingModel
                                    .reportingDate! +
                                " " +
                                bookingModel.reportingTime!.substring(0, 5)))
                            .inHours
                            .toString()
                        : _estimatedHours,
                    pickupAddress: bookingModel.pickupAddress!,
                    pickupLat: bookingModel.pickupLat!,
                    pickupLng: bookingModel.pickupLng!,
                    dropAddress: bookingModel.dropAddress!,
                    dropLat: bookingModel.dropLat!,
                    dropLng: bookingModel.dropLng!,
                    cityName: bookingModel.cityName!,
                    cityLat: bookingModel.cityLat!,
                    cityLng: bookingModel.cityLng!,
                    totalAmount: totalAmount));
                Navigator.of(context).pop();

                // feedbackDialog();
                // Navigator.pushAndRemoveUntil<void>(
                //   context,
                //   MaterialPageRoute<void>(
                //       builder: (BuildContext context) => const Dashboard()),
                //   ModalRoute.withName(AppRouter.dashboard),
                // );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> feedbackDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 2,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Polite & Professional Driver',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        // secondary: const Icon(Icons.hourglass_empty),
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Comfortable Ride',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        // secondary: const Icon(Icons.hourglass_empty),
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'Value for money',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        // secondary: const Icon(Icons.hourglass_empty),
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'My reason not listed',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        // secondary: const Icon(Icons.hourglass_empty),
                      )
                    ],
                  )),
              title: const Text('Feedback'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Submit Review'),
                  onPressed: () {
                    // if (_formKey.currentState.validate()) {
                    //   // Do something like updating SharedPreferences or User Settings etc.
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Dashboard()),
                      ModalRoute.withName(AppRouter.dashboard),
                    );
                    // }
                  },
                ),
              ],
            );
          });
        });
  }
}

class DateTimeWidget extends StatelessWidget {
  final String type;
  final DateTime? dateTime;
  const DateTimeWidget({Key? key, required this.type, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 45.0,
        width: SizeConfig.screenWidth * 0.44,
        decoration: BoxDecoration(
            border: Border.all(color: kTextOpacityColor),
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(DateFormat.yMMMMd('en_US').format(dateTime ?? DateTime.now())),
            type == "Date"
                ? const Icon(
                    Icons.calendar_month,
                    size: 20.0,
                  )
                : const Icon(
                    Icons.watch_later_outlined,
                    size: 20.0,
                  )
          ],
        ),
      ),
      const Positioned(
          top: -7.0,
          left: 10.0,
          child: Text(
            "Reporting Date",
            style: TextStyle(
                backgroundColor: kWhiteColor,
                color: kPrimaryColor,
                fontSize: 12),
          ))
    ]);
  }
}

class TimeWidget extends StatelessWidget {
  final String type;
  final TimeOfDay timeOfDay;
  const TimeWidget({Key? key, required this.type, required this.timeOfDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 45.0,
        width: SizeConfig.screenWidth * 0.44,
        decoration: BoxDecoration(
            border: Border.all(color: kTextOpacityColor),
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("${timeOfDay.hour}:${timeOfDay.minute}"),
            type == "Date"
                ? const Icon(
                    Icons.calendar_month,
                    size: 20.0,
                  )
                : const Icon(
                    Icons.watch_later_outlined,
                    size: 20.0,
                  )
          ],
        ),
      ),
      const Positioned(
          top: -7.0,
          left: 10.0,
          child: Text(
            "Reporting Time",
            style: TextStyle(
                backgroundColor: kWhiteColor,
                color: kPrimaryColor,
                fontSize: 12),
          ))
    ]);
  }
}

class BookingListItem extends StatelessWidget {
  final BuildContext context;
  late String? totalAmount;
  BookingListItem({
    required this.context,
    this.totalAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: SizeConfig.screenWidth * 0.9,
          // height: SizeConfig.screenHeight * 0.2,
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
                  decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0))),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Payment Details",
                      style: TextStyle(color: kWhiteColor),
                    ),
                  ),
                ),
              ),
              // IntrinsicHeight(
              //   child: Row(
              //     children: [
              //       const Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Text("Total Amount"),
              //       ),
              //       const Spacer(),
              //       const VerticalDivider(
              //         width: 1,
              //         color: Colors.grey,
              //       ),
              //       const Spacer(),
              //       Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Text("${getCurrency()} ${totalAmount}"),
              //       ),
              //     ],
              //   ),
              // ),
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state.status.isSubmissionSuccess &&
                      state.bookingDetailsReponse.isNotEmpty) {
                    totalAmount =
                        jsonDecode(state.bookingDetailsReponse)['invoices'][0]
                                ['netAmount']
                            .toString();

                    return Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: jsonDecode(state.bookingDetailsReponse)[
                                    'invoices'][0]['invoiceDetails']
                                .length,
                            itemBuilder: ((context, index) {
                              return Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: jsonDecode(state.bookingDetailsReponse)[
                                                                  'invoices'][0]
                                                              ['invoiceDetails']
                                                          [
                                                          index]['invoiceSubHeads']
                                                      ['invoiceSubHeadCode'] ==
                                                  'ORF'
                                              ? Text(
                                                  "${jsonDecode(state.bookingDetailsReponse)['invoices'][0]['invoiceDetails'][index]['invoiceSubHeads']['invoiceSubHeadName']} * ${jsonDecode(state.bookingDetailsReponse)['invoices'][0]['invoiceDetails'][index]['amount'] / 6} KM")
                                              : Text(
                                                  "${jsonDecode(state.bookingDetailsReponse)['invoices'][0]['invoiceDetails'][index]['invoiceSubHeads']['invoiceSubHeadName']}"),
                                        ),
                                        const Spacer(),
                                        // const VerticalDivider(
                                        //   width: 1,
                                        //   color: Colors.grey,
                                        // ),

                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "${getCurrency()} ${NumberFormat('##.0#').format(jsonDecode(state.bookingDetailsReponse)['invoices'][0]['invoiceDetails'][index]['amount'])}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                ],
                              );
                            })),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Total",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              // const VerticalDivider(
                              //   width: 1,
                              //   color: Colors.grey,
                              // ),

                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${getCurrency()} ${double.parse(jsonDecode(state.bookingDetailsReponse)['invoices'][0]['netAmount'].toString()).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: Text("Service Tax"),
                                  // ),
                                  // Divider(
                                  //   color: Colors.grey,
                                  //   height: 5.0,
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "${jsonDecode(state.bookingDetailsReponse)[0]['invoiceSubHeadName']}"),
                                  ),

                                  jsonDecode(state.bookingDetailsReponse)
                                              .length >
                                          1
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              color: Colors.grey,
                                              height: 5.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                  "${jsonDecode(state.bookingDetailsReponse)[1]['invoiceSubHeadName']}"),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 5.0,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Total"),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: Text("${getCurrency()} 0.20"),
                                  // ),
                                  // Divider(
                                  //   color: Colors.grey,
                                  //   height: 5.0,
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "${getCurrency()} ${NumberFormat("###.0#").format(jsonDecode(state.bookingDetailsReponse)[0]['amount'])}"),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 5.0,
                                  ),
                                  jsonDecode(state.bookingDetailsReponse)
                                              .length >
                                          1
                                      ? Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "${getCurrency()} ${NumberFormat("###.0#", "en_US").format(jsonDecode(state.bookingDetailsReponse)[1]['amount'])}"),
                                        )
                                      : SizedBox.shrink(),

                                  jsonDecode(state.bookingDetailsReponse)
                                              .length >
                                          1
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Divider(
                                              color: Colors.grey,
                                              height: 5.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                  "${getCurrency()} ${NumberFormat("###.0#").format(jsonDecode(state.bookingDetailsReponse)[0]['amount'] + jsonDecode(state.bookingDetailsReponse)[1]['amount'])}"),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "${getCurrency()} ${NumberFormat("###.0#").format(jsonDecode(state.bookingDetailsReponse)[0]['amount'])}"),
                                        ),
                                ],
                              ),
                            )
                          ],
                        )*/

  String getCurrency() {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: "en_in");
    print(format.currencySymbol);
    return format.currencySymbol;
  }
}
