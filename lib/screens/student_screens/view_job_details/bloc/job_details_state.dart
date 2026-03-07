part of 'job_details_bloc.dart';

@freezed
class JobDetailsState with _$JobDetailsState {
  const factory JobDetailsState.initial() = _Initial;
  const factory JobDetailsState.loading() = _Loading;
  const factory JobDetailsState.success({required CompanyResponseModel response}) = _Success;
  const factory JobDetailsState.error({required String error}) = _Error;
  
  
  
}
