import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';

part 'monthly_driver_request_event.dart';
part 'monthly_driver_request_state.dart';

class MonthlyDriverRequestBloc
    extends Bloc<MonthlyDriverRequestEvent, MonthlyDriverRequestState> {
  final AuthRepository authenticationRepository;
  MonthlyDriverRequestBloc({required this.authenticationRepository})
      : super(const MonthlyDriverRequestState()) {
    on<MonthlyDriverRequestSubmitted>(_onMonthlyRequestSubmitted);
  }

  void _onMonthlyRequestSubmitted(MonthlyDriverRequestSubmitted event,
      Emitter<MonthlyDriverRequestState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      String? response =
          await authenticationRepository.createMonthlyDriverRequest(
              event.transmissionType,
              event.dutyHours,
              event.salarybudget,
              event.natureOfDuty,
              event.selectedDays,
              event.operationCity);

      if (response != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, response: response));
      } else {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, response: response));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure, response: ""));
    }
  }
}
