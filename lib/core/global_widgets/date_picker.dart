import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../constants/size_config.dart';

class DateTimeWidget extends StatelessWidget {
  final String type;
  final String hint;
  final DateTime? dateTime;
  const DateTimeWidget(
      {Key? key,
      required this.type,
      required this.dateTime,
      required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        height: 45.0,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(color: kTextOpacityColor),
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateTime != null
                  ? Text(DateFormat.yMMMMd('en_US').format(dateTime!))
                  : const Text("Select Date"),
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
      ),
      Positioned(
          top: -7.0,
          left: 10.0,
          child: Text(
            hint,
            style: const TextStyle(
                backgroundColor: kWhiteColor,
                color: kPrimaryColor,
                fontSize: 12),
          ))
    ]);
  }
}
