import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/screens/student_screens/view_job_details/job_details_model.dart';
import 'package:gate_pass_project/screens/student_screens/view_job_details/job_details_service.dart';

part 'job_details_event.dart';
part 'job_details_state.dart';
part 'job_details_bloc.freezed.dart';

class JobDetailsBloc extends Bloc<JobDetailsEvent, JobDetailsState> {
  JobDetailsBloc() : super(_Initial()) {
    on<JobDetailsEvent>((event, emit) async {
       if (event is _ViewJobDetails) {
        emit(const JobDetailsState.loading());
        try {
          final response = await fetchJobsByCompany(event.companyId);
          if (response.isNotEmpty) {
            // Assuming the response is a list of CompanyResponseModel, take first
            emit(JobDetailsState.success(response: response.first));
          } else {
            emit(const JobDetailsState.error(error: 'No jobs found'));
          }
        } catch (e) {
          emit(JobDetailsState.error(error: e.toString()));
        }
      }
    });
  }
}
