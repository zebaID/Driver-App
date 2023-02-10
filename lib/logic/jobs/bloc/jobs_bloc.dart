import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:id_driver/data/repositories/repository.dart';
import 'package:id_driver/logic/jobs/models/jobs_response_model.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final AuthRepository authRepository;
  JobsBloc({required this.authRepository}) : super(const JobsState()) {
    on<GetJobs>(_onGetJobs);
    on<ApplyDriverJob>(_onApplyJobs);
  }

  void _onGetJobs(GetJobs event, Emitter<JobsState> emit) async {
    try {
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress, stringResponse: ""));

      final jobs = await authRepository.getJobs();
      if (jobs != null) {
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            jobs: jsonDecode(jobs)
                .map<JobsResponseModel>(
                    (booking) => JobsResponseModel.fromJson(booking))
                .toList()));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void _onApplyJobs(ApplyDriverJob event, Emitter<JobsState> emit) async {
    try {
      emit(state.copyWith(
          status: FormzStatus.submissionInProgress, stringResponse: ""));

      final applyJob = await authRepository.applyJobs(event.jobsResponseModel);
      if (applyJob != null) {
        // final jobs = await authRepository.getJobs();
        // if (jobs != null) {
        emit(
          state.copyWith(
              status: FormzStatus.submissionSuccess,
              // jobs: jsonDecode(jobs)
              //     .map<JobsResponseModel>(
              //         (booking) => JobsResponseModel.fromJson(booking))
              //     .toList(),
              stringResponse: applyJob),
        );
        // } else {
        //   emit(state.copyWith(status: FormzStatus.submissionFailure));
        // }
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
