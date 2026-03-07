import 'dart:convert';
import 'package:gate_pass_project/screens/student_screens/list_of_jobs/list_of_jobs_model.dart';
import 'package:http/http.dart' as http;
import 'package:gate_pass_project/screens/other_screen/constant_uri.dart';

Future<List<CompanyModel>> fetchCompanies() async {
  try {
    // You'll need to make a real HTTP request here.
    final response = await http.get(Uri.parse(Urlsss.listJobs));

    if (response.statusCode == 200) {
      // Decode the JSON list from the response body.
      final List<dynamic> jsonList = json.decode(response.body);

      // Map each JSON object to a CompanyModel instance.
      return jsonList.map((json) => CompanyModel.fromJson(json)).toList();
    } else {
      // Throw an exception for bad status codes.
      throw Exception('Failed to load companies: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any network or parsing errors.
    throw Exception('Failed to connect to the server: $e');
  }
}
