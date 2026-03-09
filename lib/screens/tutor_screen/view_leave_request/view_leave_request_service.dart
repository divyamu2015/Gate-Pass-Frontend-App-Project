import 'dart:convert';
import 'package:gate_pass_project/screens/tutor_screen/view_leave_request/view_leave_request_model.dart';
import 'package:http/http.dart' as http;

Future<List<LeaveRequestModel>> fetchTutorLeaveRequests(int tutorId) async {
  final url =
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor-requests/$tutorId/';

  final response = await http.get(Uri.parse(url));
//  print(url);
 // print(response);

  if (response.statusCode == 200) {
   // print(response.body);
  //  print(response.statusCode);
    final List<dynamic> jsonList = json.decode(response.body);
   // print(jsonList);

    return jsonList
        .map((jsonItem) => LeaveRequestModel.fromJson(jsonItem))
        .toList();
  } else {
    throw Exception("Failed to load leave requests");
  }
}
