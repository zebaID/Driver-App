import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/logic/booking/bloc/booking_bloc.dart';
import 'package:id_driver/logic/booking/model/assigned_booking_response_model.dart';
import 'package:id_driver/logic/booking/model/booking_response_model.dart';
import 'package:intl/intl.dart';

class MyBookings extends StatelessWidget {
  const MyBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip History"),
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Material(
              color: kPrimaryColor,
              child: TabBar(
                indicatorColor: kWhiteColor,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.amber, width: 2.0),
                ),
                tabs: [
                  Tab(
                    text: "Local",
                  ),
                  Tab(
                    text: "Outstation",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [LocalList(), OutstationList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutstationList extends StatefulWidget {
  const OutstationList({
    Key? key,
  }) : super(key: key);

  @override
  State<OutstationList> createState() => _OutstationListState();
}

class _OutstationListState extends State<OutstationList> {
  @override
  void didChangeDependencies() {
    context.read<BookingBloc>().add(GetOutstationDriverSummary());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    context.read<BookingBloc>().add(GetOutstationDriverSummary());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Center(
                child: SizedBox(
                    width: getProportionateScreenHeight(50.0),
                    height: getProportionateScreenHeight(50.0),
                    child: const CircularProgressIndicator()),
              )
            : state.driverOutstationBookingSummary.isNotEmpty
                ? ListView.builder(
                    itemCount: state.driverOutstationBookingSummary.length,
                    itemBuilder: (context, index) {
                      return BookingListItem(
                        isLocal: false,
                        bookingResponseModel:
                            state.driverOutstationBookingSummary[index],
                      );
                    })
                : const Center(child: Text("No Booking History"));
      },
    );
  }
}

class LocalList extends StatefulWidget {
  const LocalList({
    Key? key,
  }) : super(key: key);

  @override
  State<LocalList> createState() => _LocalListState();
}

class _LocalListState extends State<LocalList> {
  @override
  void didChangeDependencies() {
    context.read<BookingBloc>().add(GetLocalDriverSummary());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    context.read<BookingBloc>().add(GetLocalDriverSummary());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? Center(
                child: SizedBox(
                    width: getProportionateScreenHeight(50.0),
                    height: getProportionateScreenHeight(50.0),
                    child: const CircularProgressIndicator()),
              )
            : state.driverLocalBookingSummary.isNotEmpty
                ? ListView.builder(
                    itemCount: state.driverLocalBookingSummary.length,
                    itemBuilder: (context, index) {
                      return BookingListItem(
                        isLocal: false,
                        bookingResponseModel:
                            state.driverLocalBookingSummary[index],
                      );
                    })
                : const Center(child: Text("No Booking History"));
      },
    );
  }
}

class BookingListItem extends StatelessWidget {
  bool isLocal = false;
  AssignedBookingResponseModel bookingResponseModel;

  BookingListItem(
      {Key? key,
      required bool this.isLocal,
      required this.bookingResponseModel})
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
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: !bookingResponseModel.isOutstation!
                      ? const Text(
                          "Local Round Trip",
                          style: TextStyle(color: kWhiteColor),
                        )
                      : const Text(
                          "Outstation Round Trip",
                          style: TextStyle(color: kWhiteColor),
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
                      child: Text(
                          "${bookingResponseModel.firstName} ${bookingResponseModel.lastName}"),
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
                      child: Text(DateFormat('dd MMM yyyy').format(
                              DateTime.parse(
                                      bookingResponseModel.reportingDate!)
                                  .add(const Duration(days: 1))) +
                          " " +
                          (bookingResponseModel.reportingTime)
                              .toString()
                              .substring(0, 5)),
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
                      child: Text(DateFormat('dd MMM yyyy').format(
                              DateTime.parse(
                                      bookingResponseModel.relievingDate!)
                                  .add(const Duration(days: 1))) +
                          " " +
                          (bookingResponseModel.relievingTime)
                              .toString()
                              .substring(0, 5)),
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
                        child: Text(bookingResponseModel.pickAddress!),
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
                          "₹ ${NumberFormat("###.0#", "en_IN").format(bookingResponseModel.driverShare)}"),
                    ),
                  ],
                ),

                // TextButton(
                //   onPressed: () {
                //     showDialog(
                //         barrierDismissible: false,
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             title: Text("Sure"),
                //             content: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Text("Do you want to Accept this trip?"),
                //               ],
                //             ),
                //             actions: <Widget>[
                //               TextButton(
                //                 child: const Text('No'),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               ),
                //               TextButton(
                //                 child: const Text('Yes'),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //
                //                   // Navigator.pushAndRemoveUntil<void>(
                //                   //   context,
                //                   //   MaterialPageRoute<void>(
                //                   //       builder: (BuildContext context) => const Dashboard()),
                //                   //   ModalRoute.withName(AppRouter.dashboard),
                //                   // );
                //                 },
                //               ),
                //             ],
                //           );
                //         });
                //   },
                //   child: Text("Accept"),
                //   style: elvButtonStyle,
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
