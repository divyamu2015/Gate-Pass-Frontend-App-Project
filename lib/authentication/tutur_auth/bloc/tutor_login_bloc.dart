import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gate_pass_project/authentication/tutur_auth/tutor_login_model.dart';
import 'package:gate_pass_project/authentication/tutur_auth/tutor_login_service.dart';

part 'tutor_login_event.dart';
part 'tutor_login_state.dart';
part 'tutor_login_bloc.freezed.dart';

class TutorLoginBloc extends Bloc<TutorLoginEvent, TutorLoginState> {
  TutorLoginBloc() : super(_Initial()) {
    on<TutorLoginEvent>((event, emit) async {
      if (event is _TutorLogin) {
        emit(const TutorLoginState.loading());
        try {
          final response = await tutorLoginService(
            role: event.role,
            email: event.email,
            tutorId: event.tutorId,
          );
          emit(TutorLoginState.success(response: response));
        } catch (e) {
          emit(TutorLoginState.error(error: e.toString()));
        }
      }
    });
  }
}
