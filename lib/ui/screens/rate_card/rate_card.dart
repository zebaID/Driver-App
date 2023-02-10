import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/logic/rate_card/bloc/rate_card_bloc.dart';
import 'package:id_driver/logic/rate_card/rate_card_model.dart';

class RateCard extends StatefulWidget {
  const RateCard({Key? key}) : super(key: key);

  @override
  _RateCardState createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  @override
  void initState() {
    context.read<RateCardBloc>().add(GetRateCard());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        backgroundColor: kPrimaryColor,
        title: const Text("Rate Card"),
      ),
      body: BlocBuilder<RateCardBloc, RateCardState>(
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: state.rateCardList.length,
                  itemBuilder: ((context, index) {
                    return RateCardItem(
                      rateCardModel: state.rateCardList[index],
                    );
                  }));
        },
      ),
    );
  }
}

class RateCardItem extends StatelessWidget {
  RateCardModel rateCardModel;
  RateCardItem({Key? key, required this.rateCardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: kWhiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    rateCardModel.type == "Driver"
                        ? "Driver Rate"
                        : "Client Rate",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DriverRateWidget(
                  rateCardModel: rateCardModel,
                )
              ],
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(30.0),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(5)),
          //     color: kWhiteColor,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.5),
          //         spreadRadius: 1,
          //         blurRadius: 1,
          //         offset: const Offset(0, 1), // changes position of shadow
          //       ),
          //     ],
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: const [
          //       Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: Text(
          //           "Client Rate",
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       DriverRateWidget()
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DriverRateWidget extends StatelessWidget {
  RateCardModel rateCardModel;
  DriverRateWidget({Key? key, required this.rateCardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 228, 226, 226),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlanColumnWidget(
                      title: "Plan",
                      row1: "Base Rate",
                      row2: "Duty",
                      row3: "Overtime",
                    ),
                    PlanColumnWidget(
                      title: "Local",
                      row1: "${rateCardModel.localBase}/-",
                      row2: "4 hrs",
                      row3: "${rateCardModel.localOvertime}/hr",
                    ),
                    PlanColumnWidget(
                      title: "Outstation",
                      row1: "${rateCardModel.outstationBase}/hr",
                      row2: "10 hrs",
                      row3: "${rateCardModel.outstationOvertime}/-",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  rateCardModel.rateCard!,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "1. Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.",
              //     style: TextStyle(color: Colors.grey.shade600),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "1. Lorem ipsum dolor sit amet, consectetuer adipiscing elit",
              //     style: TextStyle(color: Colors.blueGrey.shade600),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}

class PlanColumnWidget extends StatelessWidget {
  String row1 = "";
  String row2 = "";
  String row3 = "";
  String title = "";
  PlanColumnWidget(
      {Key? key,
      required this.title,
      required this.row1,
      required this.row2,
      required this.row3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(
            color: Colors.grey,
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(row1,
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ),
          const Divider(
            color: Colors.grey,
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(row2,
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ),
          const Divider(
            color: Colors.grey,
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(row3,
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }
}
