part of 'jobs_bloc.dart';

class JobsState extends Equatable {
  final FormzStatus status;
  final List<JobsResponseModel> jobs;
  final String stringResponse;
  const JobsState(
      {this.status = FormzStatus.pure,
      this.jobs = const [],
      this.stringResponse = ""});

  JobsState copyWith(
      {FormzStatus? status,
      List<JobsResponseModel>? jobs,
      String? stringResponse}) {
    return JobsState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      stringResponse: stringResponse ?? this.stringResponse,
    );
  }

  @override
  List<Object> get props => [jobs, status, stringResponse];
}
