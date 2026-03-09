import 'dart:convert';

import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/view_stud_model.dart';
import 'package:http/http.dart' as http;

Future<List<JobApplication>> getJobApplications(int studentId) async {
  final url =
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/student/$studentId/job-applications/';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List apps = data["applications"];

    return apps.map((e) => JobApplication.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load job applications");
  }
}
