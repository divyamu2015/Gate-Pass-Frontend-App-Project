import 'dart:convert';
import 'package:gate_pass_project/screens/tutor_screen/view_attandence/view_attandence_model.dart';
import 'package:http/http.dart' as http;

Future<List<AttendanceModel>> fetchTodayAttendance(int tutorId) async {
  final url = Uri.parse(
    "https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor/$tutorId/attendance/today/"
  );

  final response = await http.get(url);
 // print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List list = data["attendance"];
    return list.map((e) => AttendanceModel.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load attendance");
  }
}
