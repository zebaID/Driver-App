part of 'monthly_driver_request_bloc.dart';

abstract class MonthlyDriverRequestEvent extends Equatable {
  const MonthlyDriverRequestEvent();

  @override
  List<Object> get props => [];
}

class MonthlyDriverRequestSubmitted extends MonthlyDriverRequestEvent {
  String transmissionType,
      dutyHours,
      selectedDays,
      salarybudget,
      natureOfDuty,
      operationCity;

  MonthlyDriverRequestSubmitted(
      this.transmissionType,
      this.dutyHours,
      this.selectedDays,
      this.salarybudget,
      this.natureOfDuty,
      this.operationCity);

  @override
  List<Object> get props => [
        transmissionType,
        dutyHours,
        selectedDays,
        salarybudget,
        natureOfDuty,
        operationCity
      ];
}
