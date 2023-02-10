import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/helper/keyboard.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/verify_otp/verify_otp.dart';

import '../../../logic/login/bloc/login_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    SizeConfig();
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      primary: kPrimaryColor,
      fixedSize: Size.fromWidth(SizeConfig.screenWidth * 0.9),
      maximumSize: const Size.fromHeight(45.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Sign In")),
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
                  const SnackBar(
                      content: Text('You cannot login by this number')),
                );
            } else if (state.status.isSubmissionSuccess) {
              if (state.loginStatus == "0") {
                {
                  print(state.otp);
                  Navigator.pushNamed(
                    mainContext,
                    AppRouter.verifyOtp,
                    arguments: {
                      'otp': state.otp,
                      'mobile': _controller.text,
                      'loginStatus': "0"
                    },
                  );

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         VerifyOtp(state.otp, "0", state.username.value)));
                }
              } else {
                {
                  print(state.otp);
                  Navigator.pushNamed(
                    mainContext,
                    AppRouter.verifyOtp,
                    arguments: {
                      'otp': state.otp,
                      'mobile': _controller.text,
                      'loginStatus': "1"
                    },
                  );

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) =>
                  //         VerifyOtp(state.otp, "1", state.username.value)));
                }
              }
            }
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                SizedBox(
                  height: getProportionateScreenHeight(50.0),
                ),
                Image.asset(
                  "assets/images/logo.png",
                  height: getProportionateScreenHeight(100.0),
                ),
                SizedBox(
                    height: getProportionateScreenHeight(
                        SizeConfig.screenHeight * 0.2)),
                _TextField(_controller, "Mobile No"),
                SizedBox(height: getProportionateScreenHeight(20.0)),
                // ElevatedButton(
                //   style: style,
                //   onPressed: () {
                //     // context.read<LoginBloc>().add(const LoginSubmitted());
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => VerifyOtp(
                //               "2345",
                //             )));
                //   },
                //   child: const Text('Signin'),
                // ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const CircularProgressIndicator()
                        : _controller.text.length == 10
                            ? ElevatedButton(
                                style: style,
                                onPressed: () {
                                  if (_controller.text.length == 10) {
                                    context
                                        .read<LoginBloc>()
                                        .add(VerifyLoginSubmitted(state.otp));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter valid mobile number')),
                                      );
                                  }
                                  print(
                                      '${state.username.status} username status');
                                },
                                child: const Text('Sign In'),
                              )
                            : const SizedBox.shrink();
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
  Widget _TextField(TextEditingController controller, String labelText) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          obscureText: false,
          controller: controller,
          maxLength: 10,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^[+]*[(]{0,1}[6-9][+]{0,9}[0-9]*$')),
          ],
          keyboardType: TextInputType.number,
          onChanged: (username) {
            context.read<LoginBloc>().add(LoginUsernameChanged(username));
            if (username.length == 10) {
              KeyboardUtil.hideKeyboard(context);
            }
          },
          decoration: InputDecoration(
              counterText: "",
              constraints: BoxConstraints(
                  maxWidth:
                      getProportionateScreenWidth(SizeConfig.screenWidth * 0.9),
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
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: kTextOpacityColor),
              ),
              errorText: state.status.isInvalid
                  ? "Please enter valid mobile number ${state.status}"
                  : null),
        );
      },
    );
  }
}

class ScreenArguments {
  final String otp;

  ScreenArguments(this.otp);
}
