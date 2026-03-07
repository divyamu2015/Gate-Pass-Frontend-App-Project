import 'dart:convert';
import 'dart:io';

import 'package:gate_pass_project/screens/other_screen/constant_uri.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/exit_button_post_model.dart';
import 'package:http/http.dart' as http;

Future<LeaveRequest> submitLeaveRequest({
  required int student,
  required int tutor,
  required int hod,
  required int department,
  required int course,
  required String reason,
  required String category,
  required DateTime date,
  required String time,
}) async {
  try {
    final Map<String, dynamic> body = {
      "student": student,
      "tutor": tutor,
      "hod": hod,
      "department": department,
      "course": course,
      "reason": reason,
      "category": category,
      "request_date": date.toIso8601String().split('T').first,
      "request_time":time
    };

    final res = await http.post(
      Uri.parse(Urlsss.postLeaveRequest), // Replace with your actual URL
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final Map<String, dynamic> decoded = jsonDecode(res.body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      final response = LeaveRequest.fromJson(decoded);
      return response;
    } else {
      throw Exception("Failed to submit leave request: ${res.statusCode}");
    }
  } on SocketException {
    throw Exception('Server Error');
  } on HttpException {
    throw Exception('Something went wrong');
  } on FormatException {
    throw Exception('Bad Request');
  } catch (e) {
    throw Exception(e.toString());
  }
}
