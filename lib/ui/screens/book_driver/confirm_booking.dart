import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/core/global_widgets/text_field.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({Key? key}) : super(key: key);

  @override
  _BookDriverState createState() => _BookDriverState();
}

class _BookDriverState extends State<ConfirmBooking>
    with TickerProviderStateMixin {
  String city = 'Pune';
  String carType = 'Manual';
  String bookingType = 'Local';
  String tripType = 'Round Trip';
  late final AnimationController _controller;

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  late TextEditingController _addresLine1;
  late TextEditingController _addresLine2;
  late TextEditingController _estHour;
  late TextEditingController _estMinute;
  late TextEditingController _promoCode;

  @override
  void initState() {
    _addresLine1 = TextEditingController();
    _addresLine2 = TextEditingController();
    _estHour = TextEditingController();
    _estMinute = TextEditingController();
    _promoCode = TextEditingController();

    _addresLine1.text = "Flat No 501";
    _addresLine2.text = "Magarpatta City";
    _estHour.text = "12";
    _estMinute.text = "00";
    _controller = AnimationController(vsync: this);
    _controller.repeat(
        reverse: true, period: Duration(milliseconds: (1 * 3000).round()));

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // Navigator.pop(context);
        _controller.reset();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _addresLine1.dispose();
    _addresLine2.dispose();
    _estHour.dispose();
    _estMinute.dispose();
    _promoCode.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: kPrimaryColor,
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
      maximumSize: const Size.fromHeight(45.0),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: Padding(
          padding: EdgeInsets.only(
              left:
                  getProportionateScreenHeight(SizeConfig.screenWidth * 0.13)),
          child: const Text("Confirm Booking"),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            AppTextField(
                readOnly: true,
                inputType: "text",
                width: 0.9,
                controller: _addresLine1,
                labelText: "Pickup & Drop Address"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            AppTextField(
                readOnly: true,
                inputType: "text",
                width: 0.9,
                controller: _addresLine2,
                labelText: "Address Line 2 (Geolocation)"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            customDropDown(0.9, 0.8, "Select City",
                ["Pune", "Mumbai", "Kolhapur"], city, "city"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateTimeWidget(
                  type: "Date",
                  dateTime: date,
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                TimeWidget(
                  type: "Time",
                  timeOfDay: time,
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customDropDown(0.44, 0.35, "Select Car Type",
                    ["Manual", "Automatic"], carType, "car"),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                customDropDown(0.44, 0.35, "Select Bookig Type",
                    ["Local", "Outstation"], bookingType, "booking"),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            customDropDown(0.9, 0.8, "Selecy Trip Type",
                ["One Way", "Round Trip"], tripType, "trip"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            const Text("Estimated Duty Hours (HM)"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                    readOnly: true,
                    inputType: "number",
                    maxLenght: 2,
                    width: 0.44,
                    controller: _estHour,
                    labelText: "Hour"),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                AppTextField(
                    readOnly: true,
                    inputType: "number",
                    maxLenght: 2,
                    width: 0.44,
                    controller: _estMinute,
                    labelText: "Minute"),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            BookingListItem(
              context: context,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            AppTextField(
                readOnly: false,
                inputType: "text",
                width: 0.9,
                controller: _promoCode,
                labelText: "Have Promocode?"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            ElevatedButton(
              style: style,
              onPressed: () {
                // Navigator.pushAndRemoveUntil<void>(
                //   context,
                //   MaterialPageRoute<void>(
                //       builder: (BuildContext context) => const Dashboard()),
                //   ModalRoute.withName(AppRouter.dashboard),
                // );
                _showMyDialog();
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
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

  Future _showTimePicker(BuildContext context) async {
    final newTime = await showTimePicker(context: context, initialTime: time);

    if (newTime == null) return;

    setState(() {
      time = newTime;
    });
  }

  Widget customDropDown(double containerSize, double itemSize, String hintText,
      List<String> values, String dropdownValue, String dropDownType) {
    return Stack(clipBehavior: Clip.none, children: [
      SizedBox(
        height: 40.0,
        width: SizeConfig.screenWidth * containerSize,
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  style: BorderStyle.solid, color: kTextOpacityColor),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          child: IgnorePointer(
            ignoring: true,
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              elevation: 16,
              style: const TextStyle(color: kBlackColor),
              underline: Container(),
              // underline: null,
              onChanged: (String? newValue) {
                if (dropDownType == "city") {
                  setState(() {
                    city = newValue!;
                  });
                } else if (dropDownType == "car") {
                  setState(() {
                    carType = newValue!;
                  });
                } else if (dropDownType == "booking") {
                  setState(() {
                    bookingType = newValue!;
                  });
                } else {
                  setState(() {
                    tripType = newValue!;
                  });
                }
              },
              items: values.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                      width: SizeConfig.screenWidth * itemSize,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value),
                      )),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      Positioned(
          top: -7.0,
          left: 10.0,
          child: Text(
            hintText,
            style: const TextStyle(
                backgroundColor: kWhiteColor,
                color: kPrimaryColor,
                fontSize: 12),
          ))
    ]);
  }

  Future<void> _showMyDialog() async {
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
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10.0)),
                Lottie.asset('assets/animations/thumb_stars.json',
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(150),
                    repeat: true
                    // controller: _controller,
                    // onLoaded: (composition) {
                    //   // Configure the AnimationController with the duration of the
                    //   // Lottie file and start the animation.
                    //   _controller
                    //     ..duration = composition.duration
                    //     ..forward();
                    // },
                    )
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
          ],
        );
      },
    );
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
  const BookingListItem({
    required this.context,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: SizeConfig.screenWidth * 0.9,
          height: SizeConfig.screenHeight * 0.2,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Service Tax"),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Local Base Fare"),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5.0,
                        ),
                        Padding(
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("${getCurrency()} 0.20"),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("${getCurrency()} 400.0"),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 5.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("${getCurrency()} 400.20"),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getCurrency() {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: "en_in");
    print(format.currencySymbol);
    return format.currencySymbol;
  }
}
