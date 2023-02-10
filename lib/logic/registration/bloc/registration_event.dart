part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegistrationMobileChanged extends RegistrationEvent {
  const RegistrationMobileChanged(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

class RegistrationFirstNameChanged extends RegistrationEvent {
  const RegistrationFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class RegistrationLastNameChanged extends RegistrationEvent {
  const RegistrationLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class RegistrationAddressLine1Changed extends RegistrationEvent {
  const RegistrationAddressLine1Changed(this.addressLine1);

  final String addressLine1;

  @override
  List<Object> get props => [addressLine1];
}

class RegistrationAddressLine2Changed extends RegistrationEvent {
  const RegistrationAddressLine2Changed(this.addressLine2);

  final String addressLine2;

  @override
  List<Object> get props => [addressLine2];
}

class RegistrationEmailChanged extends RegistrationEvent {
  const RegistrationEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class RegistrationStatesChanged extends RegistrationEvent {
  const RegistrationStatesChanged(this.state);

  final String state;

  @override
  List<Object> get props => [state];
}

class RegistrationCityChanged extends RegistrationEvent {
  const RegistrationCityChanged(this.city);

  final String city;

  @override
  List<Object> get props => [city];
}

class RegistrationSubmitted extends RegistrationEvent {
  final String city,
      addressLine1Latitude,
      addressLine1Longitude,
      addressLine1,
      mobileNumber,
      vehicleType,
      birthdate,
      drivingLicenseDate,
      middleName,
      firstName,
      lastName,
      email,
      otp,
      addressLine2;
  const RegistrationSubmitted(
      this.mobileNumber,
      this.city,
      this.addressLine1Latitude,
      this.addressLine1Longitude,
      this.addressLine1,
      this.vehicleType,
      this.birthdate,
      this.drivingLicenseDate,
      this.middleName,
      this.firstName,
      this.lastName,
      this.email,
      this.otp,
      this.addressLine2);
  @override
  List<Object> get props => [
        mobileNumber,
        city,
        addressLine1Latitude,
        addressLine1Longitude,
        addressLine1,
        vehicleType,
        birthdate,
        drivingLicenseDate,
        middleName,
        firstName,
        lastName,
        email,
        otp,
        addressLine2
      ];
}

class UpdateCustomerRequest extends RegistrationEvent {
  final String addressLine1Latitude,
      addressLine1Longitude,
      addressLine1,
      mobileNumber,
      driverType,
      middleName,
      emergencyMobileNo,
      freeAddress;
  const UpdateCustomerRequest(
      this.mobileNumber,
      this.addressLine1Latitude,
      this.addressLine1Longitude,
      this.addressLine1,
      this.driverType,
      this.middleName,
      this.emergencyMobileNo,
      this.freeAddress);
  @override
  List<Object> get props => [
        mobileNumber,
        addressLine1Latitude,
        addressLine1Longitude,
        addressLine1,
        driverType,
        middleName,
        emergencyMobileNo,
        freeAddress
      ];
}
