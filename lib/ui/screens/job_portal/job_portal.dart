import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/logic/jobs/bloc/jobs_bloc.dart';
import 'package:id_driver/logic/jobs/models/jobs_response_model.dart';

class JobPortal extends StatefulWidget {
  JobPortal({Key? key}) : super(key: key);

  @override
  State<JobPortal> createState() => _JobPortalState();
}

class _JobPortalState extends State<JobPortal> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    context.read<JobsBloc>().add(GetJobs());

    SizeConfig();
    return Scaffold(
        body: BlocListener<JobsBloc, JobsState>(
      listener: (context, state) {
        print("String resp" + state.stringResponse);
        if (state.status.isSubmissionSuccess) {
          if (state.stringResponse.isNotEmpty) {
            final res = jsonDecode(state.stringResponse);
            if (res[0]['apply_driver_job'] == "0") {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(const SnackBar(
                  content: Text("Applied Successfully!"),
                  backgroundColor: kPrimaryColor,
                ));
            } else if (res[0]['apply_driver_job'] == "1") {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((context) {
                    return AlertDialog(
                      // backgroundColor: Colors.yellow,
                      title: const Text("Alert"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [Text("Already applied for this job!")],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Okay"))
                      ],
                    );
                  }));

              // ScaffoldMessenger.of(context)
              //   ..clearSnackBars()
              //   ..showSnackBar(const SnackBar(
              //     content: Text("Already applied for this job!"),
              //     backgroundColor: Colors.yellow,
              //   ));
            } else if (res[0]['apply_driver_job'] == "2") {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((context) {
                    return AlertDialog(
                      // backgroundColor: Colors.yellow,
                      title: const Text("Alert"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                              "Come to office and fill up the Registration Form./ऑफिस मध्ये येऊन रेजिस्ट्रेशन फॉर्म भरा.")
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Okay"))
                      ],
                    );
                  }));
              // ScaffoldMessenger.of(context)
              //   ..clearSnackBars()
              //   ..showSnackBar(const SnackBar(
              //     content: Text(
              //         "Come to office and fill up the Registration Form./ऑफिस मध्ये येऊन रेजिस्ट्रेशन फॉर्म भरा."),
              //     backgroundColor: Colors.yellow,
              //   ));
            } else {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(const SnackBar(
                  content: Text("Unable to apply for this job"),
                  backgroundColor: Colors.red,
                ));
            }
          }
        }
      },
      child: BlocBuilder<JobsBloc, JobsState>(
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const Center(child: CircularProgressIndicator())
              : state.jobs.isNotEmpty
                  ? Column(
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Job: ${state.jobs.length}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        Expanded(
                          child: RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: () async {
                              context.read<JobsBloc>().add(GetJobs());
                            },
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return JobListItem(
                                  jobsResponseModel: state.jobs[index],
                                );
                              },
                              itemCount: state.jobs.length,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(child: Text("No Jobs Opening.."));
        },
      ),
    ));
  }
}

class JobListItem extends StatelessWidget {
  late JobsResponseModel jobsResponseModel;
  List<String> weekDays = [];

  JobListItem({
    required this.jobsResponseModel,
    Key? key,
  }) : super(key: key);
  getDay() {
    for (var j = 0; j < jobsResponseModel.weeklyOff!.length; j++) {
      if (jobsResponseModel.weeklyOff![j] == '1') {
        weekDays.add('Monday');
      }
      if (jobsResponseModel.weeklyOff![j] == '2') {
        weekDays.add('Tuesday');
      }
      if (jobsResponseModel.weeklyOff![j] == '3') {
        weekDays.add('Wednesday');
      }
      if (jobsResponseModel.weeklyOff![j] == '4') {
        weekDays.add('Thursday');
      }
      if (jobsResponseModel.weeklyOff![j] == '5') {
        weekDays.add('Friday');
      }
      if (jobsResponseModel.weeklyOff![j] == '6') {
        weekDays.add('Saturday');
      }
      if (jobsResponseModel.weeklyOff![j] == '7') {
        weekDays.add('Sunday');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getDay();
    final ButtonStyle elvButtonStyle = OutlinedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 18),
        fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
        maximumSize: const Size.fromHeight(45.0),
        side: const BorderSide(width: 2, color: Colors.green),
        backgroundColor: kPrimaryColor);
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
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Job ID:- ${jobsResponseModel.id!}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: kWhiteColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Area"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${jobsResponseModel.area}",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5))),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Location"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.location}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Car Name"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.vehicleName}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Car Type"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          jobsResponseModel.carType == "M"
                              ? "Manual"
                              : "Automatic",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Duty Hours"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.dutyHours} Hours, ${jobsResponseModel.dutyTime}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Weekly Off"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          weekDays.reduce(
                              (value, element) => value + ',' + element),
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Driver Age"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.driverAge}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Driving Experience"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.drivingExperience} Years Exp",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Outstation Days"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.outstationDays}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Duty Details"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${jobsResponseModel.dutyType}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                jobsResponseModel.status == "Open"
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                          child:

                              //  OutlinedButton(
                              //   style: elvButtonStyle,
                              //   onPressed: () {
                              //     showDialog(
                              //         context: context,
                              //         builder: ((context) {
                              //           return AlertDialog(
                              //             title: const Text("Confirm?"),
                              //             content: Column(
                              //               mainAxisSize: MainAxisSize.min,
                              //               children: const [
                              //                 Text(
                              //                     "Are you sure you want to Apply for this job?")
                              //               ],
                              //             ),
                              //             actions: [
                              //               TextButton(
                              //                   onPressed: () {
                              //                     Navigator.pop(context);
                              //                   },
                              //                   child: const Text("No")),
                              //               TextButton(
                              //                   onPressed: () {
                              //                     context.read<JobsBloc>().add(
                              //                         ApplyDriverJob(
                              //                             jobsResponseModel));
                              //                     Navigator.pop(context);
                              //                   },
                              //                   child: const Text("Yes"))
                              //             ],
                              //           );
                              //         }));
                              //   },
                              //   child: const Text('Apply'),
                              // )

                              ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      title: const Text("Confirm?"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                              "Are you sure you want to Apply for this job?")
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                        TextButton(
                                            onPressed: () {
                                              context.read<JobsBloc>().add(
                                                  ApplyDriverJob(
                                                      jobsResponseModel));
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"))
                                      ],
                                    );
                                  }));
                            },
                            child: const Text(
                              "Apply",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            style: elvButtonStyle,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
