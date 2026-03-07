import 'dart:convert';
import 'dart:io';

import 'package:gate_pass_project/authentication/tutur_auth/tutor_login_model.dart';
import 'package:gate_pass_project/screens/other_screen/constant_uri.dart';
import 'package:http/http.dart' as http;

Future<TutorLoginModel> tutorLoginService({
  required String role,
  required String email,
  required String tutorId,
}) async {
  try {
    final Map<String, String> body = {
      "login_id": tutorId,
      "email": email,
      "role": role,
    };
    final res = await http.post(
      Uri.parse(Urlsss.loginUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final Map<String, dynamic> decoded = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final response = TutorLoginModel.fromJson(decoded);
      return response;
    } else {
      throw Exception("Failed to login Tutor ${res.statusCode}");
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
