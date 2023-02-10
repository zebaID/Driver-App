part of 'network_connection_bloc.dart';

class NetworkConnectionState extends Equatable {
  final FormzStatus status;
  final ConnectivityResult msg;

  const NetworkConnectionState(
      {this.status = FormzStatus.pure, this.msg = ConnectivityResult.none});

  NetworkConnectionState copyWith(
      {FormzStatus? status, ConnectivityResult? msg}) {
    return NetworkConnectionState(
        status: status ?? this.status, msg: msg ?? this.msg);
  }

  @override
  List<Object> get props => [status, msg];
}
