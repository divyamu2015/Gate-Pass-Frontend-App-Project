part of 'view_stud_bloc.dart';

@freezed
class ViewStudState with _$ViewStudState {
  const factory ViewStudState.initial() = _Initial;
  const factory ViewStudState.loading() = _Loading;
  const factory ViewStudState.success({required List<JobApplication> response}) = _Success;
  const factory ViewStudState.error({required String error}) = _Error;
  
  
  
}
