import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gMap;
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/login/bloc/login_bloc.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

const gMap.LatLng _kMapCenter = gMap.LatLng(18.520430, 73.856743);
const gMap.LatLng _kMapCenter1 = gMap.LatLng(18.560430, 74.856743);
const gMap.LatLng _kMapCenter2 = gMap.LatLng(18.669030, 73.996743);

List<gMap.LatLng> lats = [
  const gMap.LatLng(18.520430, 73.856743),
  const gMap.LatLng(18.560430, 73.856743),
  const gMap.LatLng(18.640430, 73.856743)
];

class HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  gMap.GoogleMapController? controller;
  gMap.BitmapDescriptor? _markerIcon;

  late final AnimationController _animationController;
  final CarouselController _carouselController = CarouselController();
  late final TextEditingController _pickupLocationController;
  late FocusNode _pickupLocationNode;
  bool isHideBottom = false;
  double scHeight = 100.0;

  int isSelected = 0;
  int tripType = 0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  Iterable markers = [];
  static List<Map<String, dynamic>> list = [
    {"title": "one", "id": "1", "lat": 23.7985053, "lon": 90.3842538},
    {"title": "two", "id": "2", "lat": 23.802236, "lon": 90.3700},
    {"title": "three", "id": "3", "lat": 23.8061939, "lon": 90.3771193},
  ];

  static const List<String> _kOptions = <String>[
    'Pune',
    'Karve Nagar',
    'Hadapsar',
    'Magarpatta City',
  ];

  bool isKeyHidden = true;

  bool isSwitched = false;
  var textValue = 'Offline';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Online';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Offline';
      });
      print('Switch Button is OFF');
    }
  }

  final Iterable _markers = Iterable.generate(list.length, (index) {
    return gMap.Marker(
      markerId: gMap.MarkerId(list[index]['id']),
      position: gMap.LatLng(
        list[index]['lat'],
        list[index]['lon'],
      ),
      infoWindow: gMap.InfoWindow(title: list[index]["title"]),
    );
  });

  void _onFocusChange() {
    debugPrint("Focus: ${_pickupLocationNode.hasFocus.toString()}");
    // setState(() {
    //   isHideBottom = _pickupLocationNode.hasFocus;
    // });
  }

  // Future<bool> get keyboardHidden async {
  //   // If the embedded value at the bottom of the window is not greater than 0, the keyboard is not displayed.
  //   final check =
  //       () => (WidgetsBinding.instance.window.viewInsets.bottom ?? 0) <= 0;
  //   // If the keyboard is displayed, return the result directly.
  //   if (!check()) return false;
  //   // If the keyboard is hidden, in order to cope with the misjudgment caused by the keyboard display/hidden animation process, wait for 0.1 seconds and then check again and return the result.
  //   return await Future.delayed(Duration(milliseconds: 100), () => check());
  // }

  @override
  void initState() {
    setState(() {
      markers = _markers;
    });
    _animationController = AnimationController(vsync: this);
    _pickupLocationController = TextEditingController();
    _pickupLocationController.text = "Magarpatta City,Pentagon P3";
    _pickupLocationNode = FocusNode();
    _pickupLocationNode.addListener(_onFocusChange);
    // WidgetsBinding.instance?.addObserver(this);
    // _determinePosition().then((value) => getCustomerDetails());

    AuthRepository().getCityId().then((value) => null);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Location Disabled"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Your location is disabled,please enable to use the app")
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Geolocator.openLocationSettings();
                    },
                    child: const Text("Okay"))
              ],
            );
          });

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Location Permission Require!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Location permission is require to use the app")
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        permission = await Geolocator.requestPermission();
                      },
                      child: const Text("Okay"))
                ],
              );
            });

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text("Location Permission Require!"),
      //         content: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: const [
      //             Text("Location permission is require to use the app")
      //           ],
      //         ),
      //         actions: [
      //           TextButton(
      //               onPressed: () async {
      //                 Navigator.pop(context);
      Geolocator.openAppSettings();
      //               },
      //               child: const Text("Okay"))
      //         ],
      //       );
      //     });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCustomerDetails() async {
    final customerDetails = await DataProvider().getSessionData();
    final jsonCustomer = jsonDecode(customerDetails!);
    print("UserDetails $customerDetails");

    // operationCity = jsonCustomer[0]['conUsers']['operationCity'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pickupLocationController.dispose();
    _pickupLocationNode.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // @override
  // void didChangeMetrics() {
  //   // When the window insets changes, the method will be called by the system, where we can judge whether the keyboard is hidden.
  //   // If the keyboard is hidden, unfocus to end editing.
  //   keyboardHidden.then((value) =>
  //       value ? FocusManager.instance.primaryFocus?.unfocus() : null);
  // }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    // getCustomerDetails();
    SizeConfig().init(context);

    scHeight = MediaQuery.of(context).size.height;
    isKeyHidden = MediaQuery.of(context).viewInsets.bottom == 0 ? true : false;
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: gMap.GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: const gMap.CameraPosition(
                    target: _kMapCenter,
                    zoom: 7.0,
                  ),
                  gestureRecognizers: //
                      <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  // markers: <gMap.Marker>{
                  //   _createMarker(),
                  //   _createMarker1(),
                  //   _createMarker2()
                  // },
                  // markers: Set.from(markers),
                  onMapCreated: _onMapCreated,
                ),
              ),
            ),
          )
        ],
      ),
      // Align(
      //   alignment: Alignment.topCenter,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: InkWell(
      //       onTap: () {
      //         HapticFeedback.vibrate();
      //         showDialog(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return AlertDialog(
      //                 title: isSwitched ? Text("End Duty") : Text("Start Duty"),
      //                 content: Text(isSwitched
      //                     ? "Do you want to end duty?"
      //                     : "Are you ready to take trips?"),
      //                 actions: [
      //                   TextButton(
      //                       onPressed: () {
      //                         Navigator.pop(context);
      //                       },
      //                       child: Text("No")),
      //                   TextButton(
      //                       onPressed: () {
      //                         Navigator.pop(context);
      //                         toggleSwitch(!isSwitched);
      //                       },
      //                       child: Text("Yes")),
      //                 ],
      //               );
      //             });
      //       },
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: isSwitched ? Colors.green : Colors.red,
      //             borderRadius: BorderRadius.circular(5.0)),
      //         width: SizeConfig.screenWidth * 0.5,
      //         child: Padding(
      //           padding: const EdgeInsets.all(4.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               // !isSwitched
      //               //     ? const Text(
      //               //         'Offline',
      //               //         style:
      //               //             TextStyle(fontSize: 20, color: Colors.redAccent),
      //               //       )
      //               //     : const Text(
      //               //         'Offline',
      //               //         style: TextStyle(fontSize: 20, color: Colors.black),
      //               //       ),
      //               // Transform.scale(
      //               //     scale: 1,
      //               //     child: Switch(
      //               //       onChanged: toggleSwitch,
      //               //       value: isSwitched,
      //               //       activeColor: Colors.greenAccent,
      //               //       activeTrackColor: kPrimaryColor,
      //               //       inactiveThumbColor: Colors.orange,
      //               //       inactiveTrackColor: Colors.redAccent,
      //               //     )),
      //               //

      //               const Icon(
      //                 Icons.power_settings_new_outlined,
      //                 color: Colors.white,
      //                 size: 40,
      //               ),
      //               isSwitched
      //                   ? const Text(
      //                       'Online',
      //                       style: TextStyle(fontSize: 22, color: Colors.white),
      //                     )
      //                   : const Text(
      //                       'Offline',
      //                       style: TextStyle(fontSize: 22, color: Colors.white),
      //                     ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // SizedBox(
      //   height: SizeConfig.screenHeight * 0.40,
      // ),

      // isKeyHidden
      //     ? Positioned(
      //         bottom: 0.0,
      //         right: 0.0,
      //         left: 0.0,
      //         child: travelTypeCard(),
      //       )
      //     : Container(),

      // TripTypeCard(),
      // TripRoundOrOneWayCard()
    ]);
  }

  Widget _PaymentMode() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: SizeConfig.screenHeight * 0.45,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListBody(
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          splashRadius: 120,
                          splashColor: Colors.green,
                          icon: const Icon(
                            Icons.arrow_circle_left_outlined,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          onPressed: () {
                            print("Prev Tapped");
                            _carouselController.previousPage();
                            // _animationController.stop();
                          },
                        ),
                        IconButton(
                          splashRadius: 120,
                          splashColor: Colors.green,
                          icon: const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.grey,
                            size: 30.0,
                          ),
                          onPressed: () {
                            print("Next Tapped");
                            _carouselController.nextPage();

                            // _animationController.stop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Padding travelTypeCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.20,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Today's Summary",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Trips Today",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.car_rental,
                              color: kPrimaryColor,
                              size: 30.0,
                            ),
                            Text(
                              "9 Trips",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Earning",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.account_balance_wallet,
                              color: kPrimaryColor,
                              size: 30.0,
                            ),
                            Text(
                              "140.0",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget TripTypeCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.35,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tripType = 0;
                    });
                  },
                  child: Container(
                    height: getProportionateScreenWidth(130),
                    decoration: BoxDecoration(
                        color: tripType == 0 ? kPrimaryColor : kWhiteColor,
                        border: Border.all(
                          color: tripType == 0 ? kPrimaryColor : kWhiteColor,
                          //                   <--- border color
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                      children: [
                        Lottie.asset('assets/animations/map_destination.json',
                            height: getProportionateScreenHeight(100),
                            width: getProportionateScreenWidth(100),
                            animate: true),
                        Text(
                          "One Way",
                          style: TextStyle(
                            color: tripType == 0 ? kWhiteColor : kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tripType = 1;
                    });
                  },
                  child: Container(
                    height: getProportionateScreenWidth(130),
                    decoration: BoxDecoration(
                        color: tripType == 1 ? kPrimaryColor : kWhiteColor,
                        border: Border.all(
                          color: tripType == 1 ? kPrimaryColor : kWhiteColor,
                          //                   <--- border color
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                      children: [
                        Lottie.asset('assets/animations/round_trip.json',
                            height: getProportionateScreenHeight(100),
                            width: getProportionateScreenWidth(100),
                            animate: true
                            // controller: _animationController
                            ),
                        Text(
                          "Round Trip",
                          style: TextStyle(
                            color: tripType == 1 ? kWhiteColor : kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Prev Tapped");
                      _carouselController.previousPage();
                      // _animationController.stop();
                    },
                  ),
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Next Tapped");
                      _carouselController.nextPage();

                      // _animationController.stop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding PickUpTime() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.35,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Lottie.asset('assets/animations/calendar.json',
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenWidth(100),
                          animate: true
                          // controller: _animationController
                          ),
                      Text(DateFormat.yMMMMd('en_US').format(date)),
                    ],
                  ),
                  onTap: () {
                    _showDatePicker(context);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenWidth(10.0),
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Lottie.asset('assets/animations/clock.json',
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenWidth(80),
                          animate: true
                          // controller: _animationController
                          ),
                      Text("${time.hour}:${time.minute}"),
                    ],
                  ),
                  onTap: () {
                    _showTimePicker(context);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Prev Tapped");
                      _carouselController.previousPage();
                      // _animationController.stop();
                    },
                  ),
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Next Tapped");
                      _carouselController.nextPage();

                      // _animationController.stop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding DestinationCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.35,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Lottie.asset('assets/animations/location-pin.json',
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenWidth(100),
                          animate: true
                          // controller: _animationController
                          ),
                    ],
                  ),
                  onTap: () {
                    showBottomSheet();
                  },
                ),
                SizedBox(
                  height: getProportionateScreenWidth(10.0),
                ),
                const Text("Select Destination")
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Prev Tapped");
                      _carouselController.previousPage();
                      // _animationController.stop();
                    },
                  ),
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Next Tapped");
                      _carouselController.nextPage();

                      // _animationController.stop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding PaymentModeCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.35,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Lottie.asset('assets/animations/payment.json',
                          height: getProportionateScreenHeight(80),
                          width: getProportionateScreenWidth(100),
                          animate: true
                          // controller: _animationController
                          ),
                    ],
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: getProportionateScreenWidth(10.0),
                ),
                ElevatedButton(
                  child: const Text('Payment Mode'),
                  onPressed: () => _showMyDialog(),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Prev Tapped");
                      _carouselController.previousPage();
                      // _animationController.stop();
                    },
                  ),
                  IconButton(
                    splashRadius: 120,
                    splashColor: Colors.green,
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      print("Next Tapped");
                      _carouselController.nextPage();

                      // _animationController.stop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  gMap.Marker _createMarker() {
    if (_markerIcon != null) {
      return gMap.Marker(
          markerId: const gMap.MarkerId('marker_1'),
          position: _kMapCenter,
          icon: _markerIcon!,
          infoWindow: const gMap.InfoWindow(title: "Hadapsar"));
    } else {
      return const gMap.Marker(
          markerId: gMap.MarkerId('marker_1'),
          position: _kMapCenter,
          infoWindow: gMap.InfoWindow(title: "Hadapsar"));
    }
  }

  gMap.Marker _createMarker1() {
    if (_markerIcon != null) {
      return gMap.Marker(
          markerId: const gMap.MarkerId('marker_2'),
          position: _kMapCenter1,
          icon: _markerIcon!,
          // onTap: () {
          //   showModalBottomSheet<void>(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Container(
          //           color: Colors.white,
          //           child: Center(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Column(
          //                 children: <Widget>[
          //                   // TextField(
          //                   //   decoration: InputDecoration(
          //                   //       border: OutlineInputBorder(),
          //                   //       label: Text("Booking Information")),
          //                   // )
          //                   BookingListItem()
          //                 ],
          //               ),
          //             ),
          //           ),
          //         );
          //       });
          // },
          infoWindow: const gMap.InfoWindow(title: "Ahemadngar"));
    } else {
      return const gMap.Marker(
          markerId: gMap.MarkerId('marker_2'),
          position: _kMapCenter1,
          infoWindow: gMap.InfoWindow(title: "Ahemadngar"));
    }
  }

  gMap.Marker _createMarker2() {
    if (_markerIcon != null) {
      return gMap.Marker(
          markerId: const gMap.MarkerId('marker_3'),
          position: _kMapCenter2,
          icon: _markerIcon!,
          infoWindow: const gMap.InfoWindow(title: "Lohegaon"));
    } else {
      return const gMap.Marker(
          markerId: gMap.MarkerId('marker_3'),
          position: _kMapCenter2,
          infoWindow: gMap.InfoWindow(title: "Lohegaon"));
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      gMap.BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/icons/marker_icon.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(gMap.BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  void _onMapCreated(gMap.GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: scHeight,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Search Location")),
                    )
                    // Autocomplete<String>(
                    //   optionsBuilder: (TextEditingValue textEditingValue) {
                    //     if (textEditingValue.text == '') {
                    //       return const Iterable<String>.empty();
                    //     }
                    //     return _kOptions.where((String option) {
                    //       return option
                    //           .contains(textEditingValue.text.toLowerCase());
                    //     });
                    //   },
                    //   onSelected: (String selection) {
                    //     debugPrint('You just selected $selection');
                    //   },
                    // )
                    // ElevatedButton(
                    //   child: const Text('Close BottomSheet'),
                    //   onPressed: () => Navigator.pop(context),
                    // )
                  ],
                ),
              ),
            ),
          );
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
        width: SizeConfig.screenWidth * 0.40,
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
        width: SizeConfig.screenWidth * 0.40,
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
  const BookingListItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle elvButtonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 18),
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
      maximumSize: const Size.fromHeight(45.0),
    );
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        // width: SizeConfig.screenWidth * 0.9,
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
                    "Local Round Trip",
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
                      child: const Text(
                        "Booking ID",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: const Text(
                        "84350 ID",
                        style: const TextStyle(fontSize: 13),
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
                      child: const Text(
                        "Customer Name",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Devika Kulkarni",
                        style: TextStyle(fontSize: 13),
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
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Reporting Date",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "29 April 2022 1:15 PM",
                        style: TextStyle(fontSize: 13),
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
                      child: const Text(
                        "Tentative Relieving Date",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "29 April 2022 1:15 PM",
                        style: TextStyle(fontSize: 13),
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
                      child: Text(
                        "Reporting Location",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Shrinivas Housing Society,\nLine No 17,Kothrud,Pune",
                        style: TextStyle(fontSize: 13),
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
                      child: const Text(
                        "Car Type",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: const Text(
                        "Manual",
                        style: const TextStyle(fontSize: 13),
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
                      child: const Text(
                        "Estimated Driver Share",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "29 April 2022 1:15 PM",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5.0,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Sure"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Do you want to Accept this trip?"),
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
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: const Text("Accept"),
                  style: elvButtonStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
