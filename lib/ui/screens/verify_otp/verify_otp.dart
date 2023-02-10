import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/helper/keyboard.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/dashboard/dashboard.dart';
import 'package:id_driver/ui/screens/signin/signin.dart';

import '../../../logic/login/bloc/login_bloc.dart';

class VerifyOtp extends StatefulWidget {
  String otp = "";
  String loginStatus = "";
  String username = "";
  VerifyOtp();

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  String otp = "";
  String loginStatus = "";
  String username = "";
  _VerifyOtpState();

  @override
  void initState() {
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
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
    print("rcvd fdata ${rcvdData['otp']}");

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: const Text("Verify OTP"),
        backgroundColor: kPrimaryColor,
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthRepository>(context)),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Authentication Failure')),
                );
            } else if (state.status.isSubmissionSuccess &&
                state.loginStatus == "0") {
              // print(state.otp);
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Dashboard()),
                ModalRoute.withName(AppRouter.dashboard),
              );
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                SizedBox(height: getProportionateScreenHeight(50.0)),
                Image.asset(
                  "assets/images/logo.png",
                  height: getProportionateScreenHeight(100.0),
                ),
                SizedBox(height: getProportionateScreenHeight(50.0)),
                const Text(
                    'OTP has been sent to your mobile number,\n please enter it below',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kBlackColor)),
                SizedBox(height: getProportionateScreenHeight(30.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TextField(_controller1, "", _focusNode1, (text) {
                        if (text.length == 1) {
                          _focusNode2.requestFocus();
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TextField(_controller2, "", _focusNode2, (text) {
                        if (text.length == 1) {
                          _focusNode3.requestFocus();
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TextField(_controller3, "", _focusNode3, (text) {
                        if (text.length == 1) {
                          _focusNode4.requestFocus();
                        }
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _TextField(_controller4, "", _focusNode4, (text) {
                        if (text.length == 1) {
                          KeyboardUtil.hideKeyboard(context);
                        }
                      }),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20.0)),
                // ElevatedButton(
                //   style: style,
                //   onPressed: () {
                //     String enteredOTP = _controller1.text +
                //         _controller2.text +
                //         _controller3.text +
                //         _controller4.text;
                //     if (otp == enteredOTP) {
                //       if (loginStatus == "0") {
                //         Navigator.pushAndRemoveUntil<void>(
                //           context,
                //           MaterialPageRoute<void>(
                //               builder: (BuildContext context) =>
                //                   const Dashboard()),
                //           ModalRoute.withName(AppRouter.dashboard),
                //         );
                //       } else {
                //         Navigator.pushNamed(context, AppRouter.signup);
                //       }
                //     } else {
                //       ScaffoldMessenger.of(context)
                //         ..hideCurrentSnackBar()
                //         ..showSnackBar(
                //           const SnackBar(content: Text('Wrong OTP')),
                //         );
                //     }
                //   },
                //   child: const Text('Verify OTP'),
                // ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: style,
                            onPressed: () {
                              String enteredOTP = _controller1.text +
                                  _controller2.text +
                                  _controller3.text +
                                  _controller4.text;
                              if (rcvdData['otp'] == enteredOTP ||
                                  enteredOTP == state.otp) {
                                print(loginStatus);
                                if (rcvdData['loginStatus'] == "0") {
                                  context.read<LoginBloc>().add(LoginSubmitted(
                                      rcvdData['mobile'], rcvdData['otp']));
                                } else {
                                  Navigator.pushNamed(context, AppRouter.signup,
                                      arguments: {
                                        'mobile': rcvdData['mobile'],
                                        'otp': rcvdData['otp']
                                      });
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(content: Text('Wrong OTP')),
                                  );
                              }

                              // Navigator.pushNamed(
                              //   mainContext,
                              //   AppRouter.verifyOtp,
                              //   arguments: {'otp': state.otp},
                              // );
                            },
                            child: const Text('Verify OTP'),
                          );
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(20.0)),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const SizedBox.shrink()
                        : TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            onPressed: () {
                              context
                                  .read<LoginBloc>()
                                  .add(SendOTP(rcvdData['mobile']));
                            },
                            child: const Text('Resend OTP',
                                style: TextStyle(color: kTextColor)),
                          );
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _TextField(TextEditingController controller, String labelText,
      FocusNode focusNode, Function onChange) {
    return TextField(
      textAlign: TextAlign.center,
      obscureText: false,
      focusNode: focusNode,
      controller: controller,
      onChanged: (text) {
        onChange(text);
      },
      maxLength: 1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: '',
        constraints: BoxConstraints(
            maxWidth:
                getProportionateScreenWidth(SizeConfig.screenWidth * 0.18),
            minHeight: 45.0),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 2, color: kPrimaryColor.withOpacity(0.3)),
        ),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey)),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey),
        ),
        labelText: labelText,
        // labelStyle: TextStyle(color: kPrimaryColor),
        floatingLabelStyle: const TextStyle(color: kPrimaryColor),
      ),
    );
  }
}
