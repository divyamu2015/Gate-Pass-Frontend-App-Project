import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/exit_button_post_model.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/exit_service.dart';

part 'leave_button_event.dart';
part 'leave_button_state.dart';
part 'leave_button_bloc.freezed.dart';

class LeaveButtonBloc extends Bloc<LeaveButtonEvent, LeaveButtonState> {
  LeaveButtonBloc() : super(_Initial()) {
    on<LeaveButtonEvent>((event, emit) async {
      if (event is _LeaveRequest) {
        emit(const LeaveButtonState.loading());
        try {
          final response = await submitLeaveRequest(
            student: event.student,
            tutor: event.tutor,
            hod: event.hod,
            department: event.department,
            course: event.course,
            reason: event.reason,
            category: event.category,
            date: event.date,
            time: event.time,
          );
          emit(LeaveButtonState.success(response: response));
          // final response= await submitLeaveRequest(
          //   student: student,
          //   tutor: tutor, hod: hod, department: department, course: course, reason: reason, category: category, date: date, time: time)
        } catch (e) {
          emit(LeaveButtonState.error(error: e.toString()));
        }
      }
    });
  }
}
