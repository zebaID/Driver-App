import 'dart:ffi' hide Size;

import 'package:flutter/material.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/core/global_widgets/text_field.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BookDriver extends StatefulWidget {
  const BookDriver({Key? key}) : super(key: key);

  @override
  _BookDriverState createState() => _BookDriverState();
}

class _BookDriverState extends State<BookDriver> {
  String city = 'Pune';
  String carType = 'Manual';
  String bookingType = 'Local';
  String tripType = 'Round Trip';

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  late TextEditingController _addresLine1;
  late TextEditingController _addresLine2;
  late TextEditingController _estHour;
  late TextEditingController _estMinute;

  @override
  void initState() {
    _addresLine1 = TextEditingController();
    _addresLine2 = TextEditingController();
    _estHour = TextEditingController();
    _estMinute = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _addresLine1.dispose();
    _addresLine2.dispose();
    _estHour.dispose();
    _estMinute.dispose();
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
          child: const Text("Book Driver"),
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
                inputType: "text",
                width: 0.9,
                controller: _addresLine1,
                labelText: "Address Line 1"),
            SizedBox(
              height: getProportionateScreenHeight(20.0),
            ),
            AppTextField(
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
                GestureDetector(
                  child: DateTimeWidget(
                    type: "Date",
                    dateTime: date,
                  ),
                  onTap: () {
                    _showDatePicker(context);
                  },
                ),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                GestureDetector(
                  child: TimeWidget(
                    type: "Time",
                    timeOfDay: time,
                  ),
                  onTap: () {
                    _showTimePicker(context);
                  },
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
                    inputType: "number",
                    maxLenght: 2,
                    width: 0.44,
                    controller: _estHour,
                    labelText: "Hour"),
                SizedBox(
                  width: getProportionateScreenWidth(5.0),
                ),
                AppTextField(
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
              child: const Text('Pay'),
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
    TimeOfDay initialTime = TimeOfDay(
        hour: TimeOfDay.now().hour + 2, minute: TimeOfDay.now().minute);
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);

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
          title: const Text('Payment Mode'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                SizedBox(height: getProportionateScreenHeight(10.0)),
                Lottie.asset('assets/animations/payment.json',
                    height: getProportionateScreenHeight(150),
                    width: getProportionateScreenWidth(150)),
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
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRouter.confirmBooking);
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
