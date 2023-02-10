import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/login/model/driver_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../registration/validators/mobile_number.dart';
import '../model/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<VerifyLoginSubmitted>(_onSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SendOTP>(_onSendOTP);
    on<GetDriverDetails>(_onGetDriverDetails);
  }

  final AuthRepository _authenticationRepository;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _onGetDriverDetails(
      GetDriverDetails event, Emitter<LoginState> emit) async {
    try {
      final getDriverDetails = await DataProvider().getSessionData();
      final jsonDriver = jsonDecode(getDriverDetails!);
      print(
          "driverDetails ${DriverDetailsModel.fromJson(jsonDriver[0]).toJson()}");
      emit(state.copyWith(driverDetailsModel: getDriverDetails));
    } catch (e) {
      print("getDriverDetails exp $e");
    }
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = MobileNumber.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([username, state.username]),
    ));
  }

  // void _onPasswordChanged(
  //   LoginPasswordChanged event,
  //   Emitter<LoginState> emit,
  // ) {
  //   final password = Password.dirty(event.password);
  //   emit(state.copyWith(
  //     password: password,
  //     status: Formz.validate([password, state.username]),
  //   ));
  // }

  void _onSubmitted(
    VerifyLoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        String? validate = await _authenticationRepository.validateMobile(
          state.username.value,
        );
        print(validate);
        if (validate == "0" || validate == "2") {
          String? sendSMS = await _authenticationRepository.sendSMS(
            state.username.value,
          );

          String? login = await _authenticationRepository.login(
              state.username.value, sendSMS);

          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              loginStatus: "0",
              otp: sendSMS));

          // String? login = await _authenticationRepository.login(
          //   state.username.value,
          // );
          // if (login != null) {
          //   _storeSessionData(login);
          //   emit(state.copyWith(
          //     status: FormzStatus.submissionSuccess,
          //     loginStatus: "1",
          //   ));
          // } else {
          //   emit(state.copyWith(status: FormzStatus.submissionFailure));
          // }
        } else if (validate == "1") {
          String? sendSMS = await _authenticationRepository.sendSMS(
            state.username.value,
          );
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              loginStatus: "1",
              otp: sendSMS));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  void _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // if (state.status.isValidated) {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      String? login =
          await _authenticationRepository.login(event.mobileNUmber, event.otp);
      print("login Resp $login");
      if (login != null) {
        _storeSessionData(login);
        String? customerDetails =
            await AuthRepository().getCustomerDetails(event.mobileNUmber);
        if (customerDetails != null) {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            loginStatus: "0",
          ));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
      // String? validate = await _authenticationRepository.validateMobile(
      //   state.username.value,
      // );
      // print(validate);
      // if (validate == "0") {
      //   String? sendSMS = await _authenticationRepository.sendSMS(
      //     state.username.value,
      //   );
      //   emit(state.copyWith(
      //       status: FormzStatus.submissionSuccess,
      //       loginStatus: "0",
      //       otp: sendSMS));

      // } else if (validate == "1") {
      //   String? sendSMS = await _authenticationRepository.sendSMS(
      //     state.username.value,
      //   );
      //   emit(state.copyWith(
      //       status: FormzStatus.submissionSuccess,
      //       loginStatus: "1",
      //       otp: sendSMS));
      // } else {
      //   emit(state.copyWith(status: FormzStatus.submissionFailure));
      // }
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
    // }
  }

  void _onSendOTP(SendOTP event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      String? sendSMS = await _authenticationRepository.sendSMS(
        event.mobile,
      );

      String? login =
          await _authenticationRepository.login(event.mobile, sendSMS);

      if (sendSMS != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            loginStatus: "1",
            otp: sendSMS));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> _storeSessionData(String userSession) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("UserSession", userSession);
    prefs.setBool("isLoggedIn", true);
  }

  Future<void> _storeDriverData(String userSession) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("customerDetails", userSession);
  }
}
