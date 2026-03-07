part of 'view_stud_bloc.dart';

@freezed
class ViewStudEvent with _$ViewStudEvent {
  const factory ViewStudEvent.started() = _Started;
  const factory ViewStudEvent.viewJobApplication({
    required int studentId
  }) = _ViewJobApplication;
  
}