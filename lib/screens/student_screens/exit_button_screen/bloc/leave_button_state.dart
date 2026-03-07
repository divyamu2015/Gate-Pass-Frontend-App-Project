part of 'leave_button_bloc.dart';

@freezed
class LeaveButtonState with _$LeaveButtonState {
  const factory LeaveButtonState.initial() = _Initial;
  const factory LeaveButtonState.loading() = _Loading;
  const factory LeaveButtonState.success({
    required LeaveRequest response,
  }) = _Success;
  const factory LeaveButtonState.error({
    required String error
  }) = _Error;
  
  
  
}
