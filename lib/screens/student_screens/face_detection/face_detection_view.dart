import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/face_detection/face_detection_model.dart';
import 'package:gate_pass_project/screens/student_screens/face_detection/face_detection_service.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({
    super.key,
    required this.studId,
    required this.studentId,
  });
  final int studId;
  final String studentId;
  @override
  // ignore: library_private_types_in_public_api
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final AttendanceService _attendanceService = AttendanceService();
  int? studId;
  String? studentId;
  @override
  void initState() {
    super.initState();
    studId = widget.studId;
    studentId = widget.studentId;
    print("Student Id =$studId");
   print("Student password =$studentId");
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }
    if (studentId == null || studentId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Student ID missing. Please try again or contact support.',
          ),
        ),
      );
    }
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Marking attendance...')));

      final AttendanceResponse response = await _attendanceService
          .markAttendance(imageFile: _image!, studentId: widget.studentId);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Success! ${response.message}'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home screen after successful attendance
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(studId: widget.studId, studentId: widget.studentId),
        ),
      );
    } catch (e) {
      //print(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // Show actual error message
          backgroundColor: Colors.red,
        ),
      );
    }
    // print()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 140, 192, 235),
      //   leading: IconButton(
      //     onPressed: () => Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(
      //         builder: (context) =>
      //             HomeScreen(studId: studId!, studentId: studentId!),
      //       ),
      //     ),
      //     icon: const Icon(Icons.arrow_back),
      //   ),
      //   title: const Text('Mark Attendance'),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.black87,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: const Color.fromARGB(255, 8, 8, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(studId: widget.studId, studentId: widget.studentId),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 146, 146, 146),
                  ),
                  label: const Text(
                    "Back",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 110, 110, 110),
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                // const SizedBox(width: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Face Detection',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: const Color.fromARGB(179, 88, 88, 88),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Upload a clear photo for attendance.',
                style: TextStyle(
                  color: const Color.fromARGB(255, 231, 230, 230),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 140,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                backgroundColor: Colors.grey[200],
                child: _image == null
                    ? Icon(Icons.person, size: 72, color: Colors.grey[400])
                    : null,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: const Color.fromARGB(255, 151, 188, 252),
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color.fromARGB(255, 197, 213, 241),
                  shape: const StadiumBorder(),
                  elevation: 2,
                ),
                onPressed: _uploadImage,
                child: const Text(
                  "Upload & Mark Attendance",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 85, 84, 84),
                  ),
                ),
              ),

              // const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
