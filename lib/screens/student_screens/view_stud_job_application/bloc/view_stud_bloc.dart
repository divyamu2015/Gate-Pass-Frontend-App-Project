import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/view_stud_control.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/view_stud_model.dart';

part 'view_stud_event.dart';
part 'view_stud_state.dart';
part 'view_stud_bloc.freezed.dart';

class ViewStudBloc extends Bloc<ViewStudEvent, ViewStudState> {
  ViewStudBloc() : super(_Initial()) {
    on<ViewStudEvent>((event, emit) async {
      if (event is _ViewJobApplication) {
        emit(const ViewStudState.loading());
        try {
          final response = await getJobApplications(event.studentId);
          if (response.isNotEmpty) {
            // Assuming the response is a list of CompanyResponseModel, take first
           emit(ViewStudState.success(response: response));

          } else {
            emit(const ViewStudState.error(error: 'No jobs found'));
          }
        } catch (e) {
          emit(ViewStudState.error(error: e.toString()));
        }
      }
    });
  }
}
