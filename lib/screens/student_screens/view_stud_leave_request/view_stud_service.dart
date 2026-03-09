import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> fetchLeaveDetails(int studentId) async {
   final url = Uri.parse(
    "https://417sptdw-8003.inc1.devtunnels.ms/userapp/list-student-requests/$studentId/",
  );
  //print(url);

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
   //// print(response.statusCode);
    ////print(response.body);
   // print(decoded);
    return decoded; // could be Map or List
  } else {
    throw Exception("Failed to fetch data: ${response.statusCode}");
    
  }
}

