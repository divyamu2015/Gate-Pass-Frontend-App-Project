import 'dart:convert';
import 'dart:io';
import 'package:gate_pass_project/screens/student_screens/face_detection/face_detection_model.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String _baseUrl =
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/api/mark-attendance/';

  Future<AttendanceResponse> markAttendance(
      {
        required File imageFile, 
        required String studentId
        }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields['student_id'] = studentId;

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        return AttendanceResponse.fromJson(decodedResponse);
      } else {
        // Enhanced error message extraction:
        final errorMsg = decodedResponse['message'] ?? decodedResponse['error'] ?? 'Unknown server error';
        throw Exception('Failed to mark attendance. Server error: $errorMsg');
      }
    } catch (e) {
      throw Exception('An error occurred during image upload: $e');
    }
  }
}
