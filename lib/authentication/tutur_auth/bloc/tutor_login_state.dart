part of 'tutor_login_bloc.dart';

@freezed
class TutorLoginState with _$TutorLoginState {
  const factory TutorLoginState.initial() = _Initial;
  const factory TutorLoginState.loading() = _Loading;
  const factory TutorLoginState.success({required TutorLoginModel response}) =
      _Success;
  const factory TutorLoginState.error({required String error}) = _Error;
}
