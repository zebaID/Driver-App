part of 'monthly_driver_request_bloc.dart';

class MonthlyDriverRequestState extends Equatable {
  const MonthlyDriverRequestState({
    this.status = FormzStatus.pure,
    this.response = "",
  });

  final FormzStatus status;
  final String response;

  MonthlyDriverRequestState copyWith({
    FormzStatus? status,
    String? response,
  }) {
    return MonthlyDriverRequestState(
      status: status ?? this.status,
      response: response ?? this.response,
    );
  }

  @override
  List<Object> get props => [status, response];
}
