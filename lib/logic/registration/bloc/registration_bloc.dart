import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/AuthRepository.dart';
import 'package:id_driver/logic/login/model/username.dart';
import 'package:id_driver/logic/registration/validators/mobile_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authenticationRepository;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  RegistrationBloc({
    required AuthRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const RegistrationState()) {
    on<RegistrationMobileChanged>(_onMobileNumberChanges);
    on<RegistrationFirstNameChanged>(_onFirstnameChanged);
    on<RegistrationLastNameChanged>(_onLastNameChanged);
    on<RegistrationAddressLine1Changed>(_onAddressLine1Changed);
    on<RegistrationAddressLine2Changed>(_onAddressLine2Changed);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationStatesChanged>(_onStateChanged);
    on<RegistrationSubmitted>(_onSubmitted);
    on<UpdateCustomerRequest>(_onUpdateCustomerRequest);
  }

  void _onMobileNumberChanges(
    RegistrationMobileChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final mobilenumber = MobileNumber.dirty(event.mobileNumber);
    emit(state.copyWith(
      mobileNumber: mobilenumber.value,
      responseMsg: "",
      status: Formz.validate([mobilenumber]),
      isValidMobileNumber: Formz.validate([mobilenumber]),
    ));
  }

  void _onFirstnameChanged(
    RegistrationFirstNameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final firstname = Username.dirty(event.firstName);
    emit(state.copyWith(
      firstName: firstname.value,
      status: Formz.validate([firstname]),
      isValidFirstName: Formz.validate([firstname]),
    ));
  }

  void _onLastNameChanged(
    RegistrationLastNameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final lastName = Username.dirty(event.lastName);
    emit(state.copyWith(
      lastName: lastName.value,
      status: Formz.validate([lastName]),
      responseMsg: "",
      isValidLastName: Formz.validate([lastName]),
    ));
  }

  void _onAddressLine1Changed(
    RegistrationAddressLine1Changed event,
    Emitter<RegistrationState> emit,
  ) {
    final addressline1 = Username.dirty(event.addressLine1);
    print('address bloc ${state.addressLine1}');

    emit(state.copyWith(
      addressLine1: state.addressLine1,
      responseMsg: "",
      status: Formz.validate([addressline1]),
      isValidAddressLine1: Formz.validate([addressline1]),
    ));
  }

  void _onAddressLine2Changed(
    RegistrationAddressLine2Changed event,
    Emitter<RegistrationState> emit,
  ) {
    final addressline2 = Username.dirty(event.addressLine2);
    emit(state.copyWith(
      addressLine2: addressline2.value,
      responseMsg: "",
      status: Formz.validate([addressline2]),
      isValidAddressLine2: Formz.validate([addressline2]),
    ));
  }

  void _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final email = Username.dirty(event.email);
    emit(state.copyWith(
      email: email.value,
      responseMsg: "",
      status: Formz.validate([email]),
      isValidEmail: Formz.validate([email]),
    ));
  }

  void _onStateChanged(
    RegistrationStatesChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final states = Username.dirty(event.state);
    emit(state.copyWith(
      responseMsg: "",
      status: Formz.validate([states]),
    ));
  }

  void _onCityChanged(
    RegistrationCityChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final city = Username.dirty(event.city);
    print("City In Bloc $city");
    emit(state.copyWith(
      operationCity: event.city,
      responseMsg: "",
      status: Formz.validate([city]),
    ));
  }

  void _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      print('address bloc ${state.addressLine1}');

      String? validate = await _authenticationRepository.registerDriver(
          event.mobileNumber,
          event.firstName,
          event.lastName,
          event.mobileNumber + "@indian-drivers.com",
          event.city,
          event.addressLine1Latitude,
          event.addressLine1Longitude,
          event.middleName,
          "false",
          event.addressLine2,
          event.addressLine1,
          event.birthdate,
          event.drivingLicenseDate,
          event.vehicleType,
          event.otp);
      print("Registration $validate");
      final regStatus = jsonDecode(validate!);
      // emit(state.copyWith(status: FormzStatus.submissionSuccess));

      if (regStatus[0]['create_driver'] == "0") {
        String? login = await _authenticationRepository.login(
            event.mobileNumber, event.otp);

        if (login != null) {
          _storeSessionData(login);
          String? customerDetails =
              await AuthRepository().getCustomerDetails(state.mobileNumber);
          if (customerDetails != null) {
            emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              // loginStatus: "0",
            ));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, responseMsg: validate));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onUpdateCustomerRequest(
    UpdateCustomerRequest event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      print('_onUpdateCustomerRequest bloc ${event.addressLine1Latitude}');

      String? update = await _authenticationRepository.updateProfile(
          event.mobileNumber,
          state.firstName,
          state.lastName,
          event.addressLine1,
          state.addressLine2,
          state.email,
          event.addressLine1Latitude,
          event.addressLine1Longitude,
          event.middleName,
          event.emergencyMobileNo,
          event.freeAddress);
      print("Update Profile $update");
      if (update != null) {
        String? customerDetails =
            await AuthRepository().getCustomerDetails(event.mobileNumber);
        if (customerDetails != null) {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
          ));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
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
}
