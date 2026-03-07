part of 'stud_view_bloc.dart';

@freezed
class StudViewState with _$StudViewState {
  const factory StudViewState.initial() = _Initial;
  const factory StudViewState.loading() = _loading;
  const factory StudViewState.success({required LeaveDetails response }) = _Success;
  const factory StudViewState.error({required String error}) = _Error;
  
  
  
}
