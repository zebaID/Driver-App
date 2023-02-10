part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class VerifyLoginSubmitted extends LoginEvent {
  String otp;
  VerifyLoginSubmitted(this.otp);

  @override
  List<Object> get props => [otp];
}

class SendOTP extends LoginEvent {
  String mobile;
  SendOTP(this.mobile);

  @override
  List<Object> get props => [mobile];
}

class LoginSubmitted extends LoginEvent {
  String mobileNUmber;
  String otp;
  LoginSubmitted(this.mobileNUmber, this.otp);

  @override
  List<Object> get props => [mobileNUmber, otp];
}

class GetDriverDetails extends LoginEvent {}
