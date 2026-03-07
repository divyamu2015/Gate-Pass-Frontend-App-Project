part of 'leave_button_bloc.dart';

@freezed
class LeaveButtonEvent with _$LeaveButtonEvent {
  const factory LeaveButtonEvent.started() = _Started;
  const factory LeaveButtonEvent.leaveRequest(
    {
       required int student,
  required int tutor,
  required int hod,
  required int department,
  required int course,
  required String reason,
  required String category,
  required DateTime date,
  required String time,
    }
  ) = _LeaveRequest;
  
}