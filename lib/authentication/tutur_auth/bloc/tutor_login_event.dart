part of 'tutor_login_bloc.dart';

@freezed
class TutorLoginEvent with _$TutorLoginEvent {
  const factory TutorLoginEvent.started() = _Started;
  const factory TutorLoginEvent.tutorLogin({
    required String role,
    required String email,
    required String tutorId,
  }) = _TutorLogin;
  
}