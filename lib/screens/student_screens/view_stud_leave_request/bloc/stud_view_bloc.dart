import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_leave_request/view_stud_model.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_leave_request/view_stud_service.dart';

part 'stud_view_event.dart';
part 'stud_view_state.dart';
part 'stud_view_bloc.freezed.dart';

class StudViewBloc extends Bloc<StudViewEvent, StudViewState> {
  StudViewBloc() : super(_Initial()) {
    on<StudViewEvent>((event, emit) async {
      if (event is _ViewLeaveRequest) {
        emit(StudViewState.loading());
        try {
        final responseJson = await fetchLeaveDetails(event.studentId);

        // If API returned a List, pick first object (or find by id)
        Map<String, dynamic> obj;
        if (responseJson is List) {
          if (responseJson.isEmpty) {
            throw Exception('No leave requests found for this student.');
          }
          // You can change logic: maybe filter list for matching id
          obj = Map<String, dynamic>.from(responseJson.first as Map);
        } else if (responseJson is Map) {
          obj = Map<String, dynamic>.from(responseJson);
        } else {
          throw Exception('Unexpected response format from server.');
        }

        // Convert Map -> LeaveDetails model
        final model = LeaveDetails.fromJson(obj);
        emit(StudViewState.success(response: model));
      } catch (e) {
          emit(StudViewState.error(error: e.toString()));
        }
      }
    });
  }
}
