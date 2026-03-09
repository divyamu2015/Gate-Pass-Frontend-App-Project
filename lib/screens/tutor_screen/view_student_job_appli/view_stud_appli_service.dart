import 'dart:convert';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_applica_model.dart';
import 'package:http/http.dart' as http;

Future<List<ApplicationModel>> fetchAppliedStudents(int tutorId) async {
  final url = Uri.parse(
    "https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor/$tutorId/applied-students/",
  );

  final response = await http.get(url);
 // print(response.body);

  if (response.statusCode == 200) {
    List list = jsonDecode(response.body);
    return list.map((e) => ApplicationModel.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load applied students");
  }
}

Future<bool> approveApplication(int applicationId, int tutorId) async {
  final url = Uri.parse(
    "https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor/$tutorId/application/$applicationId/approve/",
  );
 // print(url);
  final res = await http.post(url);
 // print(res);
  return res.statusCode == 200 || res.statusCode == 201;
}

Future<bool> rejectApplication(int applicationId, int tutorId) async {
  final url = Uri.parse(
    "https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor/$tutorId/application/$applicationId/reject/",
  );

  final res = await http.post(url);
  return res.statusCode == 200 || res.statusCode == 201;
}
