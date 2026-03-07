import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/authentication/student_auth/student_login_model.dart';
import 'package:gate_pass_project/authentication/student_auth/student_login_service.dart';

part 'student_login_event.dart';
part 'student_login_state.dart';
part 'student_login_bloc.freezed.dart';

class StudentLoginBloc extends Bloc<StudentLoginEvent, StudentLoginState> {
  StudentLoginBloc() : super(_Initial()) {
    on<StudentLoginEvent>((event, emit) async {
      if (event is _StudentLogin) {
        emit(const StudentLoginState.loading());
        try {
          final response = await studentLoginService(
            role: event.role,
            email: event.email,
            studId: event.studentId,
          );
          emit(StudentLoginState.success(response: response));
        } catch (e) {
          emit(StudentLoginState.error(error: e.toString()));
        }
      }
    });
  }
}
