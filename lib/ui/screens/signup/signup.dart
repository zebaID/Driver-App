import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/core/global_widgets/text_field.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/model/city_model.dart';
import 'package:id_driver/logic/model/state_model.dart';
import 'package:id_driver/logic/places_autocomplete/bloc/places_autocomplete_bloc.dart';
import 'package:id_driver/logic/registration/bloc/registration_bloc.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:intl/intl.dart';

import '../../../core/global_widgets/date_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _controller4;
  late TextEditingController _stateTextController;
  late TextEditingController _cityTextController;
  late final TextEditingController _searchLocationController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _emailController;

  String _addressLine1Latitude = "";
  String _addressLine1Longitude = "";

  DateTime? date;
  DateTime? drivingLicenseDate;

  String driverType = "Car Driver";

  var state = [];
  var city = [];

  // StatesModel stateId = StatesModel(21, "Maharashtra", "MH");
  String stateId = "";
  String cityId = "";

  late GlobalKey<FormFieldState> _cityDropKey;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _controller4 = TextEditingController();
    _stateTextController = TextEditingController();
    _cityTextController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _addressLine2Controller = TextEditingController();
    _emailController = TextEditingController();
    _searchLocationController = TextEditingController();

    _stateTextController.text = "Maharashtra";
    _cityTextController.text = "Pune";

    _cityDropKey = GlobalKey();

    super.initState();

    getState();
  }

  Future<List<StatesModel>> getData() async {
    // var response = await Dio().get(
    //   "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
    //   queryParameters: {"filter": filter},
    // );

    var response = await AuthRepository().getStates();

    final data = response;
    final List<dynamic> jsonResponse = jsonDecode(data!);

    if (data != null) {
      return StatesModel.fromJsonList(jsonResponse);
    }

    return [];
  }

  Future<List> getState() async {
    String? states = await AuthRepository().getStates();
    final List<dynamic> jsonResponse = jsonDecode(states!);
    print("states ${jsonResponse}");

    setState(() {
      state.addAll(jsonResponse);
    });

    return jsonResponse;
  }

  Future<List<CityModel>> getCities() async {
    // var response = await Dio().get(
    //   "https://5d85ccfb1e61af001471bf60.mockapi.io/user",
    //   queryParameters: {"filter": filter},
    // );

    var response = await AuthRepository().getCities(stateId);

    print(response);
    final data = response;
    final List<dynamic> jsonResponse = jsonDecode(data!);

    if (data != null) {
      return CityModel.fromJsonList(jsonResponse);
    }

    return [];
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void didChangeDependencies() {
    // _determinePosition().then((value) async {
    //   print(value);
    //   final placeName = await AuthRepository()
    //       .getAddressFromCoordinates(
    //           value.latitude.toString(), value.longitude.toString())
    //       .then((value) {
    //     final jsonResponse = jsonDecode(value!);
    //     // places = jsonResponse['predictions'];
    //     print('getAddressFromCoordinates ' + value);
    //     _addressLine1Controller.text =
    //         jsonResponse['results'][0]['formatted_address'];
    //     _addressLine1Latitude = jsonResponse['results'][0]['geometry']
    //             ['location']['lat']
    //         .toString();
    //     _addressLine1Longitude = jsonResponse['results'][0]['geometry']
    //             ['location']['lng']
    //         .toString();

    //     jsonResponse['result']['address_components'].forEach((e) {
    //       if (e['types'].contains("administrative_area_level_2")) {
    //         print('Selected City ${e['long_name']}');
    //         setState(() {
    //           _cityTextController.text = e['long_name'];
    //         });
    //         _cityTextController.text = e['long_name'];
    //       }
    //     });
    //     print("City ${_cityTextController.text}");
    //   });
    // });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _mobileNumberController.dispose();
    _controller4.dispose();
    _lastNameController.dispose();
    _stateTextController.dispose();
    _cityTextController.dispose();
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

    final Map<dynamic, dynamic> rcvdData =
        ModalRoute.of(context)!.settings.arguments as Map;
    // print("rcvd fdata ${rcvdData['name']}");
    print("rcvd fdata ${rcvdData['mobile']}");

    _mobileNumberController.text = rcvdData['mobile'];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: const Text("Sign up"),
        backgroundColor: kPrimaryColor,
      ),
      body: BlocProvider(
        create: (context) => RegistrationBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthRepository>(context)),
        child: SingleChildScrollView(
          child: Center(
            child: BlocListener<RegistrationBloc, RegistrationState>(
              listener: (context, state) {
                if (state.status.isSubmissionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Registration Successfull..!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Dashboard()),
                    ModalRoute.withName(AppRouter.dashboard),
                  );
                } else {
                  if (state.status.isSubmissionFailure) {
                    final regStatus = jsonDecode(state.responseMsg);
                    if (regStatus[0]['create_driver'] == "2") {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                              content: Text('Email or Mobile Already Exist!')),
                        );
                    } else if (regStatus[0]['create_driver'] == "1") {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                              content: Text('User already registered!')),
                        );
                    }
                  }
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(
                            getProportionateScreenHeight(50.0))),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(0.5, 1))
                        ]),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: getProportionateScreenHeight(100.0),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      controller: _firstNameController,
                      labelText: "First Name",
                      onChangeText: (text) {
                        print(text);
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationFirstNameChanged(text));
                      },
                      inputType: "text"),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      controller: _middleNameController,
                      labelText: "Middle Name",
                      onChangeText: (text) {
                        print(text);
                        // context
                        //     .read<RegistrationBloc>()
                        //     .add(RegistrationFirstNameChanged(text));
                      },
                      inputType: "text"),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      controller: _lastNameController,
                      onChangeText: (text) {
                        print(text);
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationLastNameChanged(text));
                      },
                      labelText: "Last Name",
                      inputType: "text"),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  GestureDetector(
                    child: DateTimeWidget(
                      type: "Date",
                      dateTime: date,
                      hint: "Birth Date",
                    ),
                    onTap: () {
                      _showDatePicker(context, "Birthdat");
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  _TextField(
                      _mobileNumberController, "Mobile No", (text) {}, false),

                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      controller: _emailController,
                      onChangeText: (text) {
                        print(text);
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationEmailChanged(text));
                      },
                      labelText: "Email",
                      inputType: "text"),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      readOnly: true,
                      onTapText: () {
                        showSearchLocationBottomSheet(1);
                      },
                      onEditingCompleted: () {
                        print(
                            '_addressLine1Controller ${_addressLine1Controller.text}');
                        context.read<RegistrationBloc>().add(
                            RegistrationAddressLine1Changed(
                                _addressLine1Controller.text));
                      },
                      onSubmittedText: (text) {
                        print(
                            '_addressLine1Controller ${_addressLine1Controller.text}');
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationAddressLine1Changed(text));
                      },
                      controller: _addressLine1Controller,
                      onChangeText: (text) {
                        print(
                            '_addressLine1Controller ${_addressLine1Controller.text}');
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationAddressLine1Changed(text));
                      },
                      labelText: "Google Location",
                      inputType: "text"),

                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  AppTextField(
                      width: 0.9,
                      controller: _addressLine2Controller,
                      onChangeText: (text) {
                        print(text);
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationAddressLine2Changed(text));
                      },
                      labelText: "Apartment, Flat No,Landmark",
                      inputType: "text"),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  DropdownSearch<StatesModel>(
                      asyncItems: (text) => getData(),
                      popupProps:
                          const PopupProps.bottomSheet(showSearchBox: true),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          constraints: BoxConstraints(
                            maxWidth: getProportionateScreenWidth(
                                SizeConfig.screenWidth * 0.9),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: kPrimaryColor.withOpacity(0.3)),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: kTextOutlineColor)),
                          disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kTextOutlineColor),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kTextOpacityColor),
                          ),
                          labelText: "State",
                          // labelStyle: TextStyle(color: kPrimaryColor),
                          floatingLabelStyle:
                              const TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      itemAsString: (StatesModel u) => u.userAsString(),
                      onChanged: (StatesModel? data) {
                        print("${data!.id} ${data.stateName}");

                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationStatesChanged(data.id.toString()));

                        setState(() {
                          stateId = data.id.toString();
                          cityId = "";
                        });
                      }),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  DropdownSearch<CityModel>(
                      key: _cityDropKey,
                      asyncItems: (text) => getCities(),
                      popupProps:
                          const PopupProps.bottomSheet(showSearchBox: true),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          constraints: BoxConstraints(
                            maxWidth: getProportionateScreenWidth(
                                SizeConfig.screenWidth * 0.9),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: kPrimaryColor.withOpacity(0.3)),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: kTextOutlineColor)),
                          disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kTextOutlineColor),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kTextOpacityColor),
                          ),
                          labelText: "City",
                          // labelStyle: TextStyle(color: kPrimaryColor),
                          floatingLabelStyle:
                              const TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      itemAsString: (CityModel u) => u.userAsString(),
                      onChanged: (CityModel? data) {
                        print("${data!.id} ${data.cityName}");
                        context
                            .read<RegistrationBloc>()
                            .add(RegistrationCityChanged(data.cityName!));
                        setState(() {
                          cityId = data.cityName!;
                        });
                      }),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  GestureDetector(
                    child: DateTimeWidget(
                      type: "Date",
                      dateTime: drivingLicenseDate,
                      hint: "Driving License Issue Date",
                    ),
                    onTap: () {
                      _showDatePicker(context, "License");
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.9,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: kTextOpacityColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: DropdownButton<String>(
                      value: driverType,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 16,
                      style: const TextStyle(color: kBlackColor),
                      underline: Container(),
                      // underline: null,
                      onChanged: (String? newValue) {
                        // if (dropDownType == "city") {
                        //   setState(() {
                        //     city = newValue!;
                        //   });
                        // } else if (dropDownType == "car") {
                        //   setState(() {
                        //     carType = newValue!;
                        //   });
                        // } else if (dropDownType == "booking") {
                        //   setState(() {
                        //     bookingType = newValue!;
                        //   });
                        // } else {
                        //   setState(() {
                        //     tripType = newValue!;
                        //   });
                        // }
                        setState(() {
                          driverType = newValue!;
                        });
                      },
                      items: [
                        "Car Driver",
                        "Bus Driver",
                        "Truck Driver",
                        "JCB Driver",
                        "Forklift Driver",
                        "Crane Operator"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                              width: SizeConfig.screenWidth * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(value),
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20.0),
                  ),
                  // AppTextField(
                  //     width: 0.9,
                  //     readOnly: true,
                  //     controller: _stateTextController,
                  //     labelText: "I am",
                  //     onTextTap: () {
                  //       DropdownButton<String>(
                  //         value: driverType,
                  //         icon: const Icon(Icons.keyboard_arrow_down),
                  //         elevation: 16,
                  //         style: const TextStyle(color: kBlackColor),
                  //         underline: Container(),
                  //         // underline: null,
                  //         onChanged: (String? newValue) {
                  //           // if (dropDownType == "city") {
                  //           //   setState(() {
                  //           //     city = newValue!;
                  //           //   });
                  //           // } else if (dropDownType == "car") {
                  //           //   setState(() {
                  //           //     carType = newValue!;
                  //           //   });
                  //           // } else if (dropDownType == "booking") {
                  //           //   setState(() {
                  //           //     bookingType = newValue!;
                  //           //   });
                  //           // } else {
                  //           //   setState(() {
                  //           //     tripType = newValue!;
                  //           //   });
                  //           // }
                  //           setState(() {
                  //             driverType = newValue!;
                  //           });
                  //         },
                  //         items: [
                  //           "Car Driver",
                  //           "Bus Driver",
                  //           "Truck Driver",
                  //           "JCB Driver",
                  //           "Forklift Driver",
                  //           "Crane Operator"
                  //         ].map<DropdownMenuItem<String>>((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: SizedBox(
                  //                 width: SizeConfig.screenWidth * 0.9,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text(value),
                  //                 )),
                  //           );
                  //         }).toList(),
                  //       );
                  //     },
                  //     suffixIcon: true,
                  //     inputType: "text"),
                  // customDropDown(
                  //     0.9,
                  //     0.45,
                  //     "Who you are?",
                  //     [
                  //       "Car Driver",
                  //       "Bus Driver",
                  //       "Truck Driver",
                  //       "JCB Driver",
                  //       "Forklift Driver",
                  //       "Crane Operator"
                  //     ],
                  //     driverType,
                  //     "DriverType"),
                  BlocBuilder<RegistrationBloc, RegistrationState>(
                    builder: (context, state) {
                      return state.status.isSubmissionInProgress
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: style,
                              onPressed: () {
                                print(
                                    'email valid ${RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(_emailController.text)}');
                                if (date == null ||
                                    date.runtimeType == 'undfined') {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                              'Please choose birth date!')),
                                    );

                                  return;
                                }

                                if (drivingLicenseDate == null ||
                                    drivingLicenseDate.runtimeType ==
                                        'undfined') {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                              'Please choose License date!')),
                                    );

                                  return;
                                }
                                if (_mobileNumberController.text.isEmpty ||
                                    _firstNameController.text.isEmpty ||
                                    _middleNameController.text.isEmpty ||
                                    _lastNameController.text.isEmpty ||
                                    _addressLine1Controller.text.isEmpty ||
                                    _addressLine2Controller.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please fill all fields')),
                                    );
                                  return;
                                }

                                if (cityId.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 3),
                                          content:
                                              Text('Please confirm city!')),
                                    );

                                  return;
                                }

                                //  else if (!RegExp(
                                //         r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                //     .hasMatch(_emailController.text)) {
                                //   ScaffoldMessenger.of(context)
                                //     ..hideCurrentSnackBar()
                                //     ..showSnackBar(
                                //       const SnackBar(
                                //           backgroundColor: Colors.red,
                                //           content: Text('Enter Valid Email')),
                                //     );
                                //   return;
                                // }

                                else {
                                  context.read<RegistrationBloc>().add(
                                        RegistrationSubmitted(
                                            _mobileNumberController.text,
                                            cityId,
                                            _addressLine1Latitude,
                                            _addressLine1Longitude,
                                            _addressLine1Controller.text,
                                            driverType,
                                            DateFormat("yyyy/MM/dd")
                                                .format(date!),
                                            DateFormat("yyyy/MM/dd")
                                                .format(drivingLicenseDate!),
                                            _middleNameController.text,
                                            _firstNameController.text,
                                            _lastNameController.text,
                                            _emailController.text,
                                            rcvdData['otp'],
                                            _addressLine2Controller.text),
                                      );
                                }

                                // Navigator.pushNamed(
                                //   mainContext,
                                //   AppRouter.verifyOtp,
                                //   arguments: {'otp': state.otp},
                                // );
                              },
                              child: const Text('Sign up'),
                            );
                    },
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(30.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(String hint) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text(hint)),
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
              // if (dropDownType == "city") {
              //   setState(() {
              //     city = newValue!;
              //   });
              // } else if (dropDownType == "car") {
              //   setState(() {
              //     carType = newValue!;
              //   });
              // } else if (dropDownType == "booking") {
              //   setState(() {
              //     bookingType = newValue!;
              //   });
              // } else {
              //   setState(() {
              //     tripType = newValue!;
              //   });
              // }
              setState(() {
                driverType = newValue!;
              });
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

  Future _showDatePicker(BuildContext context, String type) async {
    if (type == "License") {
      final newDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 70),
          lastDate: DateTime.now());

      if (newDate == null) return;

      setState(() {
        drivingLicenseDate = newDate;
      });
    } else {
      final newDate = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime(DateTime.now().year - 18),
          firstDate: DateTime(DateTime.now().year - 70),
          lastDate: DateTime(DateTime.now().year - 18));

      if (newDate == null) return;

      setState(() {
        date = newDate;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget _TextField(TextEditingController controller, String labelText,
      Function onChange, bool enabled) {
    return TextField(
      obscureText: false,
      enabled: enabled,
      controller: controller,
      maxLength: 10,
      keyboardType: TextInputType.number,
      onChanged: (text) {
        onChange(text);
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[+]*[(]{0,1}[6-9][+]{0,1}[0-9]*$')),
      ],
      decoration: InputDecoration(
        counterText: "",
        constraints: BoxConstraints(
            maxWidth: getProportionateScreenWidth(SizeConfig.screenWidth * 0.9),
            maxHeight: 45.0),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.3)),
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: kTextOutlineColor)),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: kTextOutlineColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: kTextOpacityColor),
        ),
        labelText: labelText,
        // labelStyle: TextStyle(color: kPrimaryColor),
        floatingLabelStyle: const TextStyle(color: kPrimaryColor),
      ),
    );
  }

  void showSearchLocationBottomSheet(int type) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.96,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  BlocBuilder<PlacesAutocompleteBloc, PlacesAutocompleteState>(
                builder: (context, state) {
                  if (state.status.isSubmissionSuccess) {
                    final jsonResponse = jsonDecode(state.response);
                    // places = jsonResponse['predictions'];
                    print(jsonResponse['predictions'].length);

                    // setState(() {
                    //   places = jsonResponse['predictions'];
                    // });
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _searchLocationController,
                        onChanged: (text) {
                          // Future.delayed(Duration(seconds: 1000));
                          // autoCompleteSearch(text);
                          if (text.length > 3) {
                            context
                                .read<PlacesAutocompleteBloc>()
                                .add(PlaceAutocompleteSubmit(text));
                          }
                        },
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: const Icon(Icons.clear_rounded),
                              onTap: () {
                                _searchLocationController.clear();
                                context
                                    .read<PlacesAutocompleteBloc>()
                                    .add(PlaceAutocompleteSubmit(""));
                              },
                            ),
                            border: const OutlineInputBorder(),
                            label: Text(type == 1
                                ? "Search Your Location"
                                : type == 3
                                    ? "Search Drop Location"
                                    : "Search Outstation Location")),
                      ),
                      state.status.isSubmissionSuccess
                          ? Expanded(
                              child: ListView.builder(
                                itemCount:
                                    jsonDecode(state.response)['predictions']
                                        .length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    key: UniqueKey(),
                                    leading: const CircleAvatar(
                                      child: Icon(
                                        Icons.pin_drop,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(jsonDecode(state.response)[
                                        'predictions'][index]['description']),
                                    onTap: () async {
                                      if (jsonDecode(
                                                  state.response)['predictions']
                                              .length >
                                          0) {
                                        final placeDetails =
                                            await AuthRepository()
                                                .getPlaceDetails(
                                                    jsonDecode(state.response)[
                                                            'predictions']
                                                        [index]['place_id']);
                                        final decoded =
                                            jsonDecode(placeDetails!);
                                        debugPrint(decoded['result']
                                            ['formatted_address']);
                                        // final location =
                                        //     jsonDecode(decoded['result']['geometry']);
                                        debugPrint(
                                            decoded['result'].toString());

                                        if (type == 1) {
                                          _addressLine1Controller.text =
                                              decoded['result']
                                                  ['formatted_address'];
                                          _addressLine1Latitude =
                                              decoded['result']['geometry']
                                                      ['location']['lat']
                                                  .toString();
                                          _addressLine1Longitude =
                                              decoded['result']['geometry']
                                                      ['location']['lng']
                                                  .toString();
                                          bool isInIndia = false;

                                          // decoded['result']
                                          //         ['address_components']
                                          //     .forEach((e) {
                                          //   if (e['types']
                                          //       .contains("country")) {
                                          //     if (e['long_name'] == 'India') {
                                          //       if (e['types'].contains(
                                          //           "administrative_area_level_2")) {
                                          //         print(
                                          //             'Selected City ${e['long_name']}');
                                          //         setState(() {
                                          //           _cityTextController.text =
                                          //               e['long_name'];
                                          //         });
                                          //       }

                                          //       if (e['types'].contains(
                                          //           "administrative_area_level_1")) {
                                          //         print(
                                          //             'Selected City ${e['long_name']}');
                                          //         setState(() {
                                          //           _stateTextController.text =
                                          //               e['long_name'];
                                          //         });
                                          //       }
                                          //       _stateTextController.text =
                                          //           e['long_name'];
                                          //       print(
                                          //           "state ${_stateTextController.text} City ${_cityTextController.text}");
                                          //     } else {
                                          //       isInIndia = false;
                                          //     }
                                          //   }
                                          // });
                                          decoded['result']
                                                  ['address_components']
                                              .forEach((e) {
                                            if (e['types'].contains(
                                                "administrative_area_level_2")) {
                                              print(
                                                  'Selected City ${e['long_name']}');
                                              setState(() {
                                                _cityTextController.text =
                                                    e['long_name'];
                                              });
                                              _cityTextController.text =
                                                  e['long_name'];
                                            }
                                          });

                                          decoded['result']
                                                  ['address_components']
                                              .forEach((e) {
                                            if (e['types'].contains(
                                                "administrative_area_level_1")) {
                                              print(
                                                  'Selected State ${e['long_name']}');
                                              setState(() {
                                                _stateTextController.text =
                                                    e['long_name'];
                                              });
                                              _stateTextController.text =
                                                  e['long_name'];
                                            }

                                            print(
                                                "state ${_stateTextController.text} City ${_cityTextController.text}");
                                          });
                                        }

                                        context.read<RegistrationBloc>().add(
                                            RegistrationAddressLine1Changed(
                                                _addressLine1Controller.text));
                                        _searchLocationController.clear();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : state.status.isSubmissionInProgress
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                )
                              : const SizedBox.shrink()

                      // ElevatedButton(
                      //   child: const Text('Close BottomSheet'),
                      //   onPressed: () => Navigator.pop(context),
                      // )
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
