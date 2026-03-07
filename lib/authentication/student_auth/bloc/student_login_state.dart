part of 'student_login_bloc.dart';

@freezed
class StudentLoginState with _$StudentLoginState {
  const factory StudentLoginState.initial() = _Initial;
  const factory StudentLoginState.loading() = _Loading;
  const factory StudentLoginState.success({required StudentLoginModel response}) =
      _Success;
  const factory StudentLoginState.error({required String error}) = _Error;
}
