part of 'student_login_bloc.dart';

@freezed
class StudentLoginEvent with _$StudentLoginEvent {
  const factory StudentLoginEvent.started() = _Started;
  const factory StudentLoginEvent.studentLogin({
    required String role,
    required String email,
    required String studentId,
  }) = _StudentLogin;
  
}