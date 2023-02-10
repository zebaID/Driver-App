import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/booking/bloc/booking_bloc.dart';
import 'package:id_driver/logic/booking/model/assigned_booking_response_model.dart';
import 'package:id_driver/logic/booking/model/booking_response_model.dart';
import 'package:id_driver/logic/booking/model/current_duty_response_model.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TripInvites extends StatefulWidget {
  const TripInvites({Key? key}) : super(key: key);

  @override
  State<TripInvites> createState() => _TripInvitesState();
}

class _TripInvitesState extends State<TripInvites> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final int totalInvites = 3;

  final int totalAssignInvites = 2;

  final int totalTommorowInvites = 5;

  @override
  void initState() {
    super.initState();
    getCustomerDetails();
  }

  // @override
  // void didUpdateWidget(covariant TripInvites oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   getCustomerDetails();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getCustomerDetails() async {
    final customerDetails = await DataProvider().getSessionData();
    final jsonCustomer = jsonDecode(customerDetails!);
    print("UserDetails $customerDetails");

    String status = jsonCustomer[0]['conUsers']['status'];
    if (status == "Inactive" || status == "Blocked") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("You are $status"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                      "To view trips/on call please visit and complete registration process at Indian Drivers Office")
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRouter.contactUs);
                    },
                    child: const Text("View Address"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    context.read<BookingBloc>().add(GetBooking());

    return Scaffold(
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              debugPrint("Invitation Response" + state.response);
              if (state.status.isSubmissionSuccess &&
                  state.response.isNotEmpty) {
                List<dynamic> resp = jsonDecode(state.response);

                try {
                  resp.forEach((element) {
                    Map<String, dynamic> j = element;
                    if (j.containsKey('start_duty')) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(SnackBar(
                          content: Text(j['start_duty']),
                          backgroundColor: Colors.green,
                        ));
                      context.read<BookingBloc>().add(GetBooking());
                    } else if (j.containsKey('accept_duty')) {
                      if (j['accept_duty'] ==
                          'Already Allocated to other duty on the same day') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                        // $scope.loadDataInvitesToday();
                      } else if (j['accept_duty'] == 'Allocation Error') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else if (j['accept_duty'] ==
                          'Please Recharge Your Account to Accept this Duty') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else if (j['accept_duty'] == 'Account Error') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else if (j['accept_duty'] == 'Driver Block') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else if (j['accept_duty'] == 'License Expired') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else if (j['accept_duty'] ==
                          'Kindly Update Your License') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(SnackBar(
                            content: Text(j['accept_duty']),
                            backgroundColor: Colors.red,
                          ));
                      } else {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                              SnackBar(content: Text(j['accept_duty'])));
                        context.read<BookingBloc>().add(GetBooking());
                      }
                    } else if (j.containsKey('off_duty_for_driver')) {
                      if (j['off_duty_for_driver'] == "Done") {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(
                            content: Text("Trip Already Ended.."),
                            backgroundColor: Colors.amber,
                          ));
                      } else if (j['off_duty_for_driver'] == "Success") {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(
                            content: Text("Trip Ended.."),
                            backgroundColor: Colors.amber,
                          ));
                        context.read<BookingBloc>().add(GetBooking());
                      }
                    } else if (j.containsKey('driver_cancel_duty1')) {
                      if (j['driver_cancel_duty1'] == 'Allocation Error') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(
                            content: Text("This duty is not valid any more."),
                            backgroundColor: Colors.red,
                          ));
                      } else {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(
                            content: Text("Duty cancelled successfully.."),
                            backgroundColor: Colors.green,
                          ));
                        context.read<BookingBloc>().add(GetBooking());
                      }
                    }
                  });
                } catch (e) {
                  print('element err $e');
                }
              }
            },
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TabBar(
                        indicatorColor: Colors.amber,
                        indicator: const UnderlineTabIndicator(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        tabs: [
                          Stack(alignment: Alignment.topCenter, children: [
                            Tab(
                              text: state.currentDuty.isNotEmpty
                                  ? "Current Duty"
                                  : "Assinged Trips",
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    2.0, 1.0, 2.0, 1.0),
                                child: Text(
                                  "${state.bookingsAssigned.isEmpty && state.currentDuty.isNotEmpty ? state.currentDuty.length : state.bookingsAssigned.length}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ]),
                          Stack(alignment: Alignment.topCenter, children: [
                            const Tab(
                              text: "Today",
                            ),
                            Container(
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 1.0, 2.0, 1.0),
                                  child: Text(
                                    "${state.bookings.length}",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                          ]),
                          Stack(alignment: Alignment.topCenter, children: [
                            const Tab(
                              text: "Tomorrow",
                            ),
                            Container(
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 1.0, 2.0, 1.0),
                                  child: Text(
                                    "${state.bookingsTomorrow.length}",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        state.status.isSubmissionInProgress
                            ? Center(
                                child: SizedBox(
                                    height: getProportionateScreenHeight(50.0),
                                    width: getProportionateScreenWidth(50.0),
                                    child: const CircularProgressIndicator()))
                            : state.currentDuty.isNotEmpty
                                ? CurrentTripList()
                                : state.bookingsAssigned.isNotEmpty
                                    ? AssignedTripList()
                                    : RefreshIndicator(
                                        key: _refreshIndicatorKey,
                                        color: Colors.white,
                                        backgroundColor: Colors.blue,
                                        strokeWidth: 4.0,
                                        onRefresh: () async {
                                          return context
                                              .read<BookingBloc>()
                                              .add(GetBooking());
                                        },
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("No Assigned Trips"),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        20),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _refreshIndicatorKey
                                                      .currentState
                                                      ?.show();
                                                },
                                                child: Container(
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          0.5,
                                                  decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                          "Refresh",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        const Icon(
                                                          Icons.refresh,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                        TodaysTripList(),
                        TommorowTripList()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TommorowTripList extends StatelessWidget {
  TommorowTripList({
    Key? key,
  }) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Center(
                child: SizedBox(
                    height: getProportionateScreenHeight(50.0),
                    width: getProportionateScreenWidth(50.0),
                    child: const CircularProgressIndicator()))
            : state.bookingsTomorrow.isNotEmpty
                ? RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      return context.read<BookingBloc>().add(GetBooking());
                    },
                    child: ListView.builder(
                        itemCount: state.bookingsTomorrow.length,
                        itemBuilder: (context, index) {
                          return BookingListItem(
                            bookingResponseModel: state.bookingsTomorrow[index],
                          );
                        }),
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: () async {
                      return context.read<BookingBloc>().add(GetBooking());
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("No Invites"),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          InkWell(
                            onTap: () {
                              _refreshIndicatorKey.currentState?.show();
                            },
                            child: Container(
                              width: SizeConfig.screenWidth * 0.5,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Refresh",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
      },
    );
  }
}

class TodaysTripList extends StatelessWidget {
  TodaysTripList({
    Key? key,
  }) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Center(
                child: SizedBox(
                    height: getProportionateScreenHeight(50.0),
                    width: getProportionateScreenWidth(50.0),
                    child: const CircularProgressIndicator()))
            : state.bookings.isNotEmpty
                ? RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      return context.read<BookingBloc>().add(GetBooking());
                    },
                    child: ListView.builder(
                        itemCount: state.bookings.length,
                        itemBuilder: (context, index) {
                          return BookingListItem(
                            bookingResponseModel: state.bookings[index],
                          );
                        }),
                  )
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: () async {
                      return context.read<BookingBloc>().add(GetBooking());
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("No Invites"),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          InkWell(
                            onTap: () {
                              _refreshIndicatorKey.currentState?.show();
                            },
                            child: Container(
                              width: SizeConfig.screenWidth * 0.5,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Refresh",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
      },
    );
  }
}

class CurrentTripList extends StatelessWidget {
  CurrentTripList({
    Key? key,
  }) : super(key: key);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            return context.read<BookingBloc>().add(GetBooking());
          },
          child: ListView.builder(
              itemCount: state.currentDuty.length,
              itemBuilder: (context, index) {
                return CurrentDutyListItem(
                  bookingResponseModel: state.currentDuty[index],
                );
              }),
        );
      },
    );
  }
}

class AssignedTripList extends StatelessWidget {
  AssignedTripList({
    Key? key,
  }) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            return context.read<BookingBloc>().add(GetBooking());
          },
          child: ListView.builder(
              itemCount: state.bookingsAssigned.length,
              itemBuilder: (context, index) {
                return RecentBookingListItem(
                  bookingResponseModel: state.bookingsAssigned[index],
                );
              }),
        );
      },
    );
  }
}

class BookingListItem extends StatelessWidget {
  BookingListItem({Key? key, required this.bookingResponseModel})
      : super(key: key);

  BookingResponseModel bookingResponseModel;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elvButtonStyle = ElevatedButton.styleFrom(
      primary: kPrimaryColor,
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.5),
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
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bookingResponseModel.isOutstation == false &&
                          bookingResponseModel.isRoundTrip == true
                      ? const Text(
                          "Local Round Trip",
                          style: TextStyle(color: kWhiteColor, fontSize: 18),
                        )
                      : bookingResponseModel.isOutstation == false &&
                              bookingResponseModel.isRoundTrip == false
                          ? const Text(
                              "Local One Way Trip",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 18),
                            )
                          : bookingResponseModel.isOutstation == true &&
                                  bookingResponseModel.isRoundTrip == true
                              ? const Text(
                                  "Outstation Round Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                )
                              : const Text(
                                  "Outstation One Way Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Booking ID"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.bookingId!),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Customer Name"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bookingResponseModel.firstName! +
                            " " +
                            bookingResponseModel.lastName!),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.reportingDate!.substring(0, 10)}T${bookingResponseModel.reportingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Tentative Relieving Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.relievingDate!.substring(0, 10)}T${bookingResponseModel.relievingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Location"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bookingResponseModel.landmark! +
                            "," +
                            bookingResponseModel.pickAddress!),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Car Type"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.carType == "M"
                          ? "Manual"
                          : "Automatic"),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Estimated Driver Share"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "₹ ${bookingResponseModel.driverShare!.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
                bookingResponseModel.isOutstation!
                    ? Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Outstation City"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${bookingResponseModel.outstationCity}"),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocListener<BookingBloc, BookingState>(
                      listener: (context, state) {},
                      child: BlocBuilder<BookingBloc, BookingState>(
                        builder: (context, state) {
                          return state.status.isSubmissionInProgress
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Sure"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    "Do you want to Accept this trip?"),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Yes'),
                                                onPressed: () {
                                                  context
                                                      .read<BookingBloc>()
                                                      .add(AcceptBooking(
                                                          bookingResponseModel
                                                              .bookingId!,
                                                          bookingResponseModel));

                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text("Accept"),
                                  style: elvButtonStyle,
                                );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentDutyListItem extends StatelessWidget {
  CurrentDutyListItem({Key? key, required this.bookingResponseModel})
      : super(key: key);

  CurrentDutyResponseModel bookingResponseModel;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elvButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.5),
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
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bookingResponseModel.isOutstation == false &&
                          bookingResponseModel.isRoundTrip == true
                      ? const Text(
                          "Local Round Trip",
                          style: TextStyle(color: kWhiteColor, fontSize: 18),
                        )
                      : bookingResponseModel.isOutstation == false &&
                              bookingResponseModel.isRoundTrip == false
                          ? const Text(
                              "Local One Way Trip",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 18),
                            )
                          : bookingResponseModel.isOutstation == true &&
                                  bookingResponseModel.isRoundTrip == true
                              ? const Text(
                                  "Outstation Round Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                )
                              : const Text(
                                  "Outstation One Way Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Booking ID"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.bookingId!),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Customer Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.firstName! +
                          " " +
                          bookingResponseModel.lastName!),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.reportingDate!.substring(0, 10)}T${bookingResponseModel.reportingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Tentative Relieving Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.relievingDate!.substring(0, 10)}T${bookingResponseModel.relievingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Location"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bookingResponseModel.landmark! +
                            "," +
                            bookingResponseModel.pickAddress!),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Car Type"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.carType == "M"
                          ? "Manual"
                          : "Automatic"),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Estimated Driver Share"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "₹ ${bookingResponseModel.driverShare!.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm!",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Do you want to call customer?")
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
                                    Navigator.pop(context);
                                    launchUrl(Uri.parse(
                                        "tel:${bookingResponseModel.mobileNumber}"));
                                  },
                                  child: const Text("Yes"))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Call To Customer"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.phone,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocListener<BookingBloc, BookingState>(
                      listener: (context, state) {},
                      child: BlocBuilder<BookingBloc, BookingState>(
                        builder: (context, state) {
                          return state.status.isSubmissionInProgress
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        AppRouter.bookingDetails,
                                        arguments: {
                                          'bookingResponseModel':
                                              bookingResponseModel
                                        });
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return AlertDialog(
                                    //         title: const Text("Confirmation!"),
                                    //         content: Column(
                                    //           mainAxisSize: MainAxisSize.min,
                                    //           children: const [
                                    //             Text(
                                    //                 "Do you want to Off the Duty?")
                                    //           ],
                                    //         ),
                                    //         actions: [
                                    //           TextButton(
                                    //               onPressed: () {
                                    //                 Navigator.pop(context);
                                    //               },
                                    //               child: const Text("No")),
                                    //           TextButton(
                                    //               onPressed: () {
                                    //                 Navigator.of(context)
                                    //                     .pushNamed(
                                    //                         AppRouter
                                    //                             .bookingDetails,
                                    //                         arguments: {
                                    //                       'bookingResponseModel':
                                    //                           bookingResponseModel
                                    //                     });
                                    //               },
                                    //               child: const Text("Yes"))
                                    //         ],
                                    //       );
                                    //     });
                                  },
                                  child: const Text("Off Duty"),
                                  style: elvButtonStyle,
                                );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecentBookingListItem extends StatelessWidget {
  RecentBookingListItem({Key? key, required this.bookingResponseModel})
      : super(key: key);

  AssignedBookingResponseModel bookingResponseModel;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elvButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.8),
      maximumSize: const Size.fromHeight(45.0),
    );
    final ButtonStyle cancelButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.red,
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.8),
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
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bookingResponseModel.isOutstation == false &&
                          bookingResponseModel.isRoundTrip == true
                      ? const Text(
                          "Local Round Trip",
                          style: TextStyle(color: kWhiteColor, fontSize: 18),
                        )
                      : bookingResponseModel.isOutstation == false &&
                              bookingResponseModel.isRoundTrip == false
                          ? const Text(
                              "Local One Way Trip",
                              style:
                                  TextStyle(color: kWhiteColor, fontSize: 18),
                            )
                          : bookingResponseModel.isOutstation == true &&
                                  bookingResponseModel.isRoundTrip == true
                              ? const Text(
                                  "Outstation Round Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                )
                              : const Text(
                                  "Outstation One Way Trip",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 18),
                                ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Booking ID"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.id!),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Customer Name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.firstName! +
                          " " +
                          bookingResponseModel.lastName!),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.reportingDate!.substring(0, 10)}T${bookingResponseModel.reportingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Tentative Relieving Date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("dd MMM yyyy hh:mm aa").format(
                          DateTime.parse(
                                  "${bookingResponseModel.relievingDate!.substring(0, 10)}T${bookingResponseModel.relievingTime!}.000Z")
                              .add(const Duration(days: 1)))),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Reporting Location"),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(bookingResponseModel.landmark! +
                            "," +
                            bookingResponseModel.pickAddress!),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Car Type"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(bookingResponseModel.carType == "M"
                          ? "Manual"
                          : "Automatic"),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Estimated Driver Share"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "₹ ${bookingResponseModel.driverShare!.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
                bookingResponseModel.isOutstation!
                    ? Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Outstation City"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${bookingResponseModel.outstationCity}"),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm!",
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Do you want to call customer?")
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
                                    Navigator.pop(context);
                                    launchUrl(Uri.parse(
                                        "tel:${bookingResponseModel.mobileNumber}"));
                                  },
                                  child: const Text("Yes"))
                            ],
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Call To Customer"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.phone,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                bookingResponseModel.startDutyFlag! ||
                        bookingResponseModel.cancelDutyFlag!
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bookingResponseModel.startDutyFlag!
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Sure"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Text(
                                                        "Do you want to start this trip?"),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      context
                                                          .read<BookingBloc>()
                                                          .add(StartDuty(
                                                              bookingResponseModel));
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text("Start Duty"),
                                      style: elvButtonStyle,
                                    )
                                  : const SizedBox.shrink(),
                              bookingResponseModel.cancelDutyFlag!
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Sure"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Text(
                                                        "Do you want to Cancel this trip?"),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();

                                                      context
                                                          .read<BookingBloc>()
                                                          .add(CancelDuty(
                                                              bookingResponseModel));
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text("Cancel Duty"),
                                      style: cancelButtonStyle,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "To Start or Cancel Duty Kindly Contact Indian Drivers Office",
                          style: TextStyle(color: Colors.orange, fontSize: 14),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
