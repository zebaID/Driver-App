part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  final FormzStatus status;
  final List<WalletResponseModel> response;
  final String stringResponse;
  final List<DriverAccountModel> driverAccount;
  const WalletState(
      {this.status = FormzStatus.pure,
      this.response = const [],
      this.driverAccount = const [],
      this.stringResponse = ""});

  WalletState copyWith(
      {FormzStatus? status,
      List<WalletResponseModel>? response,
      String? stringResponse,
      List<DriverAccountModel>? driverAccount}) {
    return WalletState(
      status: status ?? this.status,
      response: response ?? this.response,
      stringResponse: stringResponse ?? this.stringResponse,
      driverAccount: driverAccount ?? this.driverAccount,
    );
  }

  @override
  List<Object> get props => [status, response, stringResponse, driverAccount];
}
