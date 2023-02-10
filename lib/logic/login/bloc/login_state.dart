part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState(
      {this.status = FormzStatus.pure,
      this.username = const MobileNumber.pure(),
      this.loginStatus = "",
      this.otp = "",
      this.driverDetailsModel = ""});

  final FormzStatus status;
  final MobileNumber username;
  final String loginStatus;
  final String otp;
  final String driverDetailsModel;

  LoginState copyWith(
      {FormzStatus? status,
      MobileNumber? username,
      String? loginStatus,
      String? otp,
      String? driverDetailsModel}) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      loginStatus: loginStatus ?? this.loginStatus,
      otp: otp ?? this.otp,
      driverDetailsModel: driverDetailsModel ?? this.driverDetailsModel,
    );
  }

  @override
  List<Object> get props =>
      [status, username, loginStatus, otp, driverDetailsModel];
}
