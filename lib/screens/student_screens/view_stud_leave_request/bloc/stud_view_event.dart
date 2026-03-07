part of 'stud_view_bloc.dart';

@freezed
class StudViewEvent with _$StudViewEvent {
  const factory StudViewEvent.started() = _Started;
  const factory StudViewEvent.viewLeaveRequest({
    required int studentId
  }) = _ViewLeaveRequest;
  
}