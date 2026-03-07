import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/authentication/student_auth/bloc/student_login_bloc.dart';
//import 'package:gate_pass_project/authentication/student_auth/student_login_view.dart';
import 'package:gate_pass_project/authentication/tutur_auth/bloc/tutor_login_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/bloc/leave_button_bloc.dart';
import 'package:gate_pass_project/screens/other_screen/splash_screen.dart';
import 'package:gate_pass_project/screens/student_screens/view_job_details/bloc/job_details_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/bloc/view_stud_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_leave_request/bloc/stud_view_bloc.dart';
//import 'package:gate_pass_project/screens/home_page/home_page.dart';
//import 'package:gate_pass_project/authentication/student_auth/student_login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StudentLoginBloc()),
        BlocProvider(create: (context) => TutorLoginBloc()),
        BlocProvider(
          create: (context) => JobDetailsBloc(),
        //  child: Container(),
        ),
        BlocProvider(
          create: (context) => LeaveButtonBloc(),
        //  child: Container(),
        ),
         BlocProvider(
          create: (context) => ViewStudBloc(),
        //  child: Container(),
        ),
          BlocProvider(
          create: (context) => StudViewBloc(),
        //  child: Container(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home:
           // TutorLoginPage(),
            SplashScreen(),
           // JobRulesReg(),
         //  RoleSelectionScreen()
          // HomeScreen()
      ),
    );
  }
}
