part of 'registration_bloc.dart';

// abstract class RegistrationState extends Equatable {
//   const RegistrationState();

//   @override
//   List<Object> get props => [];
// }

// class RegistrationInitial extends RegistrationState {}

class RegistrationState extends Equatable {
  const RegistrationState(
      {this.status = FormzStatus.pure,
      this.mobileNumber = "",
      this.isValidMobile = FormzStatus.pure,
      this.firstName = "",
      this.isValidFirstName = FormzStatus.pure,
      this.lastName = "",
      this.isValidLastName = FormzStatus.pure,
      this.addressLine1 = "",
      this.isValidAddressLine1 = FormzStatus.pure,
      this.addressLine2 = "",
      this.isValidAddressLine2 = FormzStatus.pure,
      this.email = "",
      this.isValidEmail = FormzStatus.pure,
      this.address = "",
      this.isValidAddress = FormzStatus.pure,
      this.addressLat = "",
      this.isValidAddressLat = FormzStatus.pure,
      this.addressLong = "",
      this.isValidAddressLong = FormzStatus.pure,
      this.landmark = "",
      this.operationCity = "",
      this.otp = "",
      this.password = "",
      this.userDevice = "",
      this.username = "",
      this.isValidUsername = FormzStatus.pure,
      this.responseMsg = ""});

  final FormzStatus status;
  final String mobileNumber;
  final FormzStatus isValidMobile;
  final String firstName;
  final FormzStatus isValidFirstName;
  final String lastName;
  final FormzStatus isValidLastName;
  final String addressLine1;
  final FormzStatus isValidAddressLine1;
  final String addressLine2;
  final FormzStatus isValidAddressLine2;
  final String email;
  final FormzStatus isValidEmail;
  final String username;
  final FormzStatus isValidUsername;
  final String password;
  final String otp;
  final String landmark;
  final String addressLat;
  final FormzStatus isValidAddressLat;
  final String addressLong;
  final FormzStatus isValidAddressLong;
  final String address;
  final FormzStatus isValidAddress;
  final String userDevice;
  final String operationCity;
  final String responseMsg;

  RegistrationState copyWith({
    FormzStatus? status,
    String? mobileNumber,
    FormzStatus? isValidMobileNumber,
    String? firstName,
    FormzStatus? isValidFirstName,
    String? lastName,
    FormzStatus? isValidLastName,
    String? addressLine1,
    FormzStatus? isValidAddressLine1,
    String? addressLine2,
    FormzStatus? isValidAddressLine2,
    String? email,
    FormzStatus? isValidEmail,
    String? username,
    FormzStatus? isValidUserame,
    String? password,
    String? otp,
    String? landmark,
    String? addressLat,
    FormzStatus? isValidAddressLat,
    String? addressLong,
    FormzStatus? isValidAddressLong,
    String? address,
    FormzStatus? isValidAddress,
    String? userDevice,
    String? operationCity,
    String? responseMsg,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      isValidAddress: isValidAddress ?? this.isValidAddress,
      isValidMobile: isValidMobile ?? this.isValidMobile,
      isValidAddressLat: isValidAddressLat ?? this.isValidAddressLat,
      isValidLastName: isValidLastName ?? this.isValidLastName,
      isValidFirstName: isValidFirstName ?? this.isValidFirstName,
      isValidAddressLine1: isValidAddressLine1 ?? this.isValidAddressLine1,
      isValidAddressLine2: isValidAddressLine2 ?? this.isValidAddressLine2,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      landmark: landmark ?? this.landmark,
      addressLat: addressLat ?? this.addressLat,
      addressLong: addressLong ?? this.addressLong,
      address: address ?? this.address,
      userDevice: userDevice ?? this.userDevice,
      operationCity: operationCity ?? this.operationCity,
      responseMsg: responseMsg ?? this.responseMsg,
    );
  }

  @override
  List<Object> get props => [
        status,
        firstName,
        lastName,
        mobileNumber,
        addressLine1,
        addressLine2,
        email,
        username,
        password,
        otp,
        landmark,
        addressLat,
        addressLong,
        address,
        userDevice,
        operationCity,
        responseMsg
      ];
}
