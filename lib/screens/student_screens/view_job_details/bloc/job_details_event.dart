part of 'job_details_bloc.dart';

@freezed
class JobDetailsEvent with _$JobDetailsEvent {
  const factory JobDetailsEvent.started() = _Started;
  const factory JobDetailsEvent.viewJobDetails({
    required int companyId
  }) = _ViewJobDetails;
  
}