part of 'jobs_bloc.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object> get props => [];
}

class GetJobs extends JobsEvent {}

class ApplyDriverJob extends JobsEvent {
  late JobsResponseModel jobsResponseModel;

  ApplyDriverJob(this.jobsResponseModel);

  @override
  List<Object> get props => [jobsResponseModel];
}
