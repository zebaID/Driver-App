import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/helper/keyboard.dart';
import 'package:id_driver/logic/places_autocomplete/bloc/places_autocomplete_bloc.dart';
import 'package:id_driver/logic/registration/bloc/registration_bloc.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/global_widgets/date_picker.dart';
import '../../../core/global_widgets/text_field.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _mobileNoController;
  late TextEditingController _emergencyMobileNoController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _emailController;
  late TextEditingController _lastNameController;
  late TextEditingController _stateTextController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _cityTextController;
  late TextEditingController _freeAddressController;

  late final TextEditingController _searchLocationController;

  String _addressLine1Latitude = "";
  String _addressLine1Longitude = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DateTime date = DateTime.now();
  DateTime drivingLicenseDate = DateTime.now();

  String driverType = "Car Driver";

  bool enableUpdate = false;
  String _trDate = "";
  String _ntDate = "";
  String _experiance = "";
  String _age = "";
  String _operationCity = "";
  String _permenantAddress = "";

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _mobileNoController = TextEditingController();
    _emergencyMobileNoController = TextEditingController();
    _addressLine1Controller = TextEditingController();
    _emailController = TextEditingController();
    _lastNameController = TextEditingController();
    _stateTextController = TextEditingController();
    _cityTextController = TextEditingController();
    _searchLocationController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _freeAddressController = TextEditingController();

    _stateTextController.text = "Maharashtra";
    _cityTextController.text = "Pune";

    getCustomerDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _mobileNoController.dispose();
    _addressLine1Controller.dispose();
    _emailController.dispose();
    _lastNameController.dispose();
    _stateTextController.dispose();
    _cityTextController.dispose();
    _searchLocationController.dispose();
    _vehicleTypeController.dispose();
    _emergencyMobileNoController.dispose();
    _freeAddressController.dispose();
  }

  void getCustomerDetails() async {
    final customerDetails = await DataProvider().getSessionData();
    final jsonCustomer = jsonDecode(customerDetails!);
    print("UserDetails $customerDetails");

    _mobileNoController.text = jsonCustomer[0]['conUsers']['mobileNumber'];
    _firstNameController.text = jsonCustomer[0]['conUsers']['firstName'];
    _middleNameController.text = jsonCustomer[0]['conUsers']['middleName'];
    _lastNameController.text = jsonCustomer[0]['conUsers']['lastName'];
    _addressLine1Controller.text = jsonCustomer[0]['conUsers']['address'];
    _emailController.text = jsonCustomer[0]['conUsers']['email'];
    _vehicleTypeController.text = jsonCustomer[0]['vehicle'];
    if (jsonCustomer[0]['freeAddress'] != null) {
      _freeAddressController.text =
          jsonCustomer[0]['freeAddress'].toString().replaceAll('\n', ',');
    } else {
      _freeAddressController.text = "";
    }

    _emergencyMobileNoController.text = jsonCustomer[0]['emergencyNumber'];
    if (jsonCustomer[0]['Experience'] != null) {
      _experiance = jsonCustomer[0]['Experience'];
    } else {
      _experiance = "";
    }
    _operationCity = jsonCustomer[0]['conUsers']['operationCity'];
    if (jsonCustomer[0]['permanentAddress'] != null) {
      _permenantAddress = jsonCustomer[0]['permanentAddress'];
    } else {
      _permenantAddress = "";
    }

    _addressLine1Latitude =
        jsonCustomer[0]['conUsers']['addressLat'].toString();
    _addressLine1Longitude =
        jsonCustomer[0]['conUsers']['addressLong'].toString();

    context
        .read<RegistrationBloc>()
        .add(RegistrationFirstNameChanged(_firstNameController.text));

    context
        .read<RegistrationBloc>()
        .add(RegistrationLastNameChanged(_lastNameController.text));

    context
        .read<RegistrationBloc>()
        .add(RegistrationEmailChanged(_emailController.text));

    setState(() {
      try {
        date = DateTime.parse(jsonCustomer[0]['BDate']);
        _age =
            (DateTime.now().difference(date).inDays / 365).toInt().toString();
        drivingLicenseDate = DateTime.parse(jsonCustomer[0]['licenseDate']);
        if (jsonCustomer[0]['trDate'] != null) {
          _trDate = DateFormat.yMMMMd('en_US')
              .format(DateTime.parse(jsonCustomer[0]['trDate']));
        }
        if (jsonCustomer[0]['ntDate'] != null) {
          _ntDate = DateFormat.yMMMMd('en_US')
              .format(DateTime.parse(jsonCustomer[0]['ntDate']));
        }
      } catch (e) {
        print("Birthdate null $e");
      }
    });
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
        title: const Text("Profile"),
        backgroundColor: kPrimaryColor,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [Text("Do you want to logout?")],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("No")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              clearSession();
                            },
                            child: const Text("Yes"))
                      ],
                    );
                  });
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(const SnackBar(
                content: Text("Profile Updated Successfully.."),
                duration: Duration(
                  seconds: 2,
                ),
                backgroundColor: Colors.green,
              ));
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Dashboard()),
              ModalRoute.withName(AppRouter.dashboard),
            );
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(const SnackBar(
                content: Text("Unable to updated profile.."),
                duration: Duration(
                  seconds: 2,
                ),
                backgroundColor: Colors.red,
              ));
          }
        },
        child: SingleChildScrollView(
          child: Center(
            child: BlocBuilder<RegistrationBloc, RegistrationState>(
              builder: (context, state) {
                return Column(
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
                    state.isValidFirstName.isValid
                        ? AppTextField(
                            width: 0.9,
                            readOnly: true,
                            controller: _firstNameController,
                            labelText: "First Name",
                            onChangeText: (text) {
                              print(text);
                              context
                                  .read<RegistrationBloc>()
                                  .add(RegistrationFirstNameChanged(text));
                            },
                            inputType: "text")
                        : AppTextField(
                            width: 0.9,
                            enableErr: true,
                            readOnly: true,
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
                        readOnly: true,
                        controller: _middleNameController,
                        labelText: "Middle Name",
                        onChangeText: (text) {
                          print(text);
                        },
                        inputType: "text"),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    state.isValidLastName.isValid
                        ? AppTextField(
                            width: 0.9,
                            readOnly: true,
                            controller: _lastNameController,
                            labelText: "Last Name",
                            onChangeText: (text) {
                              print(text);
                              context
                                  .read<RegistrationBloc>()
                                  .add(RegistrationLastNameChanged(text));
                            },
                            inputType: "text")
                        : AppTextField(
                            width: 0.9,
                            enableErr: true,
                            readOnly: true,
                            controller: _lastNameController,
                            labelText: "Last Name",
                            onChangeText: (text) {
                              print(text);
                              context
                                  .read<RegistrationBloc>()
                                  .add(RegistrationLastNameChanged(text));
                            },
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
                        // _showDatePicker(context, "Birthdat");
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    AppTextField(
                        width: 0.9,
                        controller: _mobileNoController,
                        labelText: "Mobile Number",
                        readOnly: true,
                        onChangeText: (text) {
                          print(text);
                          context
                              .read<RegistrationBloc>()
                              .add(RegistrationMobileChanged(text));
                        },
                        inputType: "text"),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    AppTextField(
                        width: 0.9,
                        controller: _emergencyMobileNoController,
                        labelText: "Emergency Mobile Number",
                        maxLenght: 10,
                        onTapText: () {},
                        onChangeText: (text) {
                          if (text.toString().length == 10) {
                            KeyboardUtil.hideKeyboard(context);
                          }
                          setState(() {});
                        },
                        inputType: "number"),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    AppTextField(
                        width: 0.9,
                        controller: _freeAddressController,
                        onTapText: () {},
                        onChangeText: (text) {
                          setState(() {});
                        },
                        labelText: "Apartment, Flat No,Landmark",
                        inputType: "text"),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    AppTextField(
                        width: 0.9,
                        readOnly: true,
                        onTapText: () {
                          // showSearchLocationBottomSheet(1);
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
                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(_permenantAddress.isEmpty
                                ? "Not added"
                                : _permenantAddress),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "Permanent Address",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    AppTextField(
                        width: 0.9,
                        readOnly: true,
                        controller: _vehicleTypeController,
                        labelText: "I'm a",
                        onTapText: () {
                          // showBottomSheet("Search State");
                        },
                        suffixIcon: false,
                        inputType: "text"),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),

                    // AppTextField(
                    //     width: 0.9,
                    //     readOnly: true,
                    //     controller: _stateTextController,
                    //     labelText: "City",
                    //     onTapText: () {
                    //       showBottomSheet("Search City");
                    //     },
                    //     suffixIcon: true,
                    //     inputType: "text"),
                    // SizedBox(
                    //   height: getProportionateScreenHeight(20.0),
                    // ),
                    GestureDetector(
                      child: DateTimeWidget(
                        type: "Date",
                        dateTime: drivingLicenseDate,
                        hint: "Driving License Issue Date",
                      ),
                      onTap: () {
                        // _showDatePicker(context, "License");
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("License Expiry"),
                    ),

                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                                Text(_trDate.isEmpty ? "Not added" : _trDate),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "TR Expiry Date",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),

                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                                Text(_ntDate.isEmpty ? "Not added" : _ntDate),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "NT Expiry Date",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),

                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(_experiance.isEmpty
                                ? "Not added"
                                : _experiance),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "Experience",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),

                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(_age.isEmpty ? "Not added" : _age),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "Age",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),
                    Stack(fit: StackFit.loose, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: kTextOpacityColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(_operationCity.isEmpty
                                ? "Not added"
                                : _operationCity),
                          ),
                        ),
                      ),
                      const Positioned.fill(
                          top: 0,
                          left: 20,
                          child: Text(
                            "Operation City",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                color: kPrimaryColor,
                                fontSize: 12),
                          )),
                    ]),

                    SizedBox(
                      height: getProportionateScreenHeight(20.0),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "*To update profile page contact Indian Drivers office",
                        style: TextStyle(color: Colors.amber, fontSize: 13),
                      ),
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
                    _emergencyMobileNoController.text.length == 10 &&
                            _freeAddressController.text.isNotEmpty
                        ? state.status.isSubmissionInProgress
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: style,
                                onPressed: () {
                                  // Navigator.pushAndRemoveUntil<void>(
                                  //   context,
                                  //   MaterialPageRoute<void>(
                                  //       builder: (BuildContext context) =>
                                  //           const Dashboard()),
                                  //   ModalRoute.withName(AppRouter.dashboard),
                                  // );
                                  print("updating");
                                  context.read<RegistrationBloc>().add(
                                      UpdateCustomerRequest(
                                          _mobileNoController.text,
                                          _addressLine1Latitude,
                                          _addressLine1Longitude,
                                          _addressLine1Controller.text,
                                          driverType,
                                          _middleNameController.text,
                                          _emergencyMobileNoController.text,
                                          _freeAddressController.text));
                                },
                                child: const Text('Update'),
                              )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: getProportionateScreenHeight(30.0),
                    ),
                  ],
                );
              },
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
                          border: const OutlineInputBorder(),
                          label: Text(hint)),
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
  Widget _TextField(TextEditingController controller, String labelText) {
    return TextField(
      obscureText: false,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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

  void clearSession() async {
    final SharedPreferences prefs = await _prefs;

    prefs.clear();

    _finishAccountCreation();
  }

  void _finishAccountCreation() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const SignIn()),
      ModalRoute.withName('/'),
    );
  }
}
