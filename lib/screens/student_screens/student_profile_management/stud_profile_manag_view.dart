import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StudentProfileScreen extends StatefulWidget {
  final int studId;
  final String studentId;

  const StudentProfileScreen({super.key, required this.studId,required this.studentId});

  @override
  // ignore: library_private_types_in_public_api
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late Future<Map<String, dynamic>> _studentFuture;
  int? studId;
  File? _imageFile;
  @override
  void initState() {
    super.initState();
    studId = widget.studId;
    print('Student Profile Management $studId');
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    _studentFuture = fetchStudentData(widget.studId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchStudentData(int id) async {
    final url = Uri.parse(
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/student/$id/profile/',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load student data');
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected to upload.')),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Uploading image...',style: TextStyle(color: Colors.green),)));

    final url = Uri.parse(
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/student/${widget.studId}/update/',
    );

    final request = http.MultipartRequest('PATCH', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', _imageFile!.path),
    );

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          _studentFuture = Future.value(decodedResponse['data']);
          _imageFile = null;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(studId: widget.studId,studentId: widget.studentId,)
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to upload image. Error: ${decodedResponse['message']}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(studId: studId!),
            ),
          ),
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Student Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final student = snapshot.data!;

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () => _showImageSourceActionSheet(context),
                    //   child:
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[350],
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : NetworkImage(
                                      'https://417sptdw-8003.inc1.devtunnels.ms${student['image']}',
                                    )
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  _showImageSourceActionSheet(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ),
                    const SizedBox(height: 16),
                    Text(
                      student['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            _buildInfoRow('Gender', student['gender'] ?? ''),
                            _buildInfoRow('Email', student['email'] ?? ''),
                            _buildInfoRow('Phone', student['phone'] ?? ''),
                            _buildInfoRow('Address', student['address'] ?? ''),
                            _buildInfoRow(
                              'Date of Birth',
                              student['dob'] ?? '',
                            ),
                            _buildInfoRow('Batch', student['batch'] ?? ''),
                            _buildInfoRow(
                              'Student ID',
                              student['student_id'] ?? '',
                            ),
                            _buildInfoRow(
                              'Register Number',
                              student['register_number'] ?? '',
                            ),
                            _buildInfoRow(
                              'Roll Number',
                              student['roll_number'] ?? '',
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: _imageFile != null
                                  ? _uploadImage
                                  : null,
                              label: Text('Upload'),
                              icon: Icon(Icons.upload_file),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
