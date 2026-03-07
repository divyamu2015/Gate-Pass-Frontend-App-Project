import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/bloc/leave_button_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/exit_button_screen/exit_button_model.dart';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:http/http.dart' as http;

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key, required this.studId});
  final int studId;

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  String? department;
  String? tutor;
  bool isUrgent = false;
  DateTime? leaveDate;
  Student? students;
  bool isLoading = true;
  String? errorMessage;
  int? studId;
  int? hodId;
  int? tutorId;
  bool isloading = false;
  int? departmentId;
  int? courseId;
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController tutorController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    studId = widget.studId;
   // print('LeaveRequestScreen  $studId');
    leaveDate = DateTime.now();
    getData();
  }

  Future<void> getData() async {
    final url =
        'https://t3845w6p-8003.inc1.devtunnels.ms/userapp/student/$studId/';
   // print('LeaveRequestScreen url;=$url');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          students = Student.fromJson(data);
          hodId = students!.hod;
        //  print('Leaverequest Hod= $hodId');
          tutorId = students!.tutor;
         // print('Leaverequest Hod= $tutorId');
          departmentId = students!.department;
         // print('Leaverequest department= $department');
          courseId = students!.course;
         // print('Leaverequest course= $courseId');
          nameController.text = students!.name;
          deptController.text = students!.departmentName;
          tutorController.text = students!.tutorName;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> submitRequest() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeNow = TimeOfDay.now();
    final timeString =
        '${timeNow.hour.toString().padLeft(2, '0')}:${timeNow.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen(studId: studId!);
                },
              ),
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<LeaveButtonBloc, LeaveButtonState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              setState(() => isloading = true);
            },
            success: (response) {
              setState(() => isloading = false);
              final status = response.status ;

              if (status == 'HOD Approved') {
                // Only now show success + navigate to QR screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Leave approved by HOD. Generating QR..."),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => AutoQrGenerationScreen(
                //       data: LeaveDetails(
                //         id: response.id,
                //         studentName: response.studentName,
                //         tutorName: response.tutorName,
                //         hodName: response.hodName,
                //         departmentName: response.departmentName,
                //         courseName: response.courseName,
                //         requestDate: response.requestDate,
                //         requestTime: response.requestTime,
                //         reason: response.reason,
                //         category: response.category,
                //         status: response.status,
                //         forwardedToHod: response.forwardedToHod,
                //         qrCode: response.qrCode,
                //         isLeaved: response.isLeaved,
                //         createdAt: response.createdAt,
                //       ),
                //     ),
                //   ),
                // );
              } else {
                // For any other status, just show current status, no QR
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Current status: $status'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            error: (error) {
              setState(() => isloading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $error"),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          String currentStatus = 'Pending'; // default when first opened
          String currentCategory = isUrgent ? 'Urgent' : 'Not Urgent';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                SizedBox(height: 12),
                // ProcessTimeline(
                //   status: currentStatus,
                //   category: currentCategory,
                // ),

                const SizedBox(height: 24),
                Text("Name"),
                SizedBox(height: 6),
                TextFormField(
                  controller: nameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    //hintText: "Select your department",
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 18),
                Text("Department"),
                SizedBox(height: 6),
                TextFormField(
                  controller: deptController,
                  readOnly: true,
                  decoration: InputDecoration(
                    //   hintText: "Select your department",
                    prefixIcon: Icon(Icons.apartment_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 18),
                Text("Tutor"),
                SizedBox(height: 6),
                TextFormField(
                  controller: tutorController,
                  readOnly: true,
                  decoration: InputDecoration(
                    //  hintText: "Select your tutor",
                    prefixIcon: Icon(Icons.school_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 18),
                Text("Urgency"),
                SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isUrgent = false),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              "Normal",
                              style: TextStyle(
                                color: !isUrgent
                                    ? Colors.green
                                    : Colors.black87,
                                fontWeight: !isUrgent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isUrgent = true),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              "Urgent",
                              style: TextStyle(
                                color: isUrgent ? Colors.red : Colors.black87,
                                fontWeight: isUrgent
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Text("Leave Date"),
                SizedBox(height: 6),
                InputDecorator(
                  decoration: InputDecoration(
                    //  hintText: "Select a date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                    enabled: false,
                  ),
                  child: Text(
                    leaveDate != null
                        ? "${leaveDate!.day}/${leaveDate!.month}/${leaveDate!.year}"
                        : "Select a date",
                    style: TextStyle(
                      color: leaveDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Text("Current Time"),
                SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        timeNow.format(context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Text("Reason for Leave"),
                SizedBox(height: 6),
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Briefly explain your reason for absence...",
                    prefixIcon: Icon(Icons.edit_note_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.blue,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (reasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a reason')),
                      );
                      return;
                    }

                    context.read<LeaveButtonBloc>().add(
                      LeaveButtonEvent.leaveRequest(
                        student: studId ?? 0,
                        tutor: tutorId ?? 0,
                        hod: hodId ?? 0,
                        department: departmentId ?? 0,
                        course: courseId ?? 0,
                        reason: reasonController.text,
                        category: isUrgent ? 'Urgent' : 'Not Urgent',
                        date: leaveDate ?? DateTime.now(),
                        time: timeString,
                      ),
                    );
                  },

                  child: isloading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Request",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
// ProcessTimeline Widget - Add this class below your LeaveRequestScreen
class ProcessTimeline extends StatelessWidget {
  final String status;
  final String category;

  const ProcessTimeline({
    super.key,
    required this.status,
    required this.category,
  });

  double _getProgress() {
    // Normal flow: Pending -> Tutor Approved -> HOD Approved
    if (category == 'Not Urgent') {
      if (status == 'Pending') {
        return 0.0; // 0%
      } else if (status == 'Tutor Approved') {
        return 0.5; // 50%
      } else if (status == 'HOD Approved') {
        return 1.0; // 100%
      } else {
        return 0.0;
      }
    }

    // Urgent flow: Pending -> HOD Approved (skip tutor)
    if (category == 'Urgent') {
      if (status == 'Pending') {
        return 0.0; // 0%
      } else if (status == 'HOD Approved') {
        return 1.0; // 100%
      } else {
        return 0.0;
      }
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    Color activeColor = Colors.green;
    Color inactiveColor = Colors.grey.shade400;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Process Timeline',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category == 'Urgent' ? 'Urgent Request' : 'Normal Request',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // Progress dots and connecting lines
          Row(
            children: [
              // Pending dot
              _buildStepDot(
                isActive: progress >= 0.0,
                label: 'Pending',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),

              // Line to next step
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 24),
                  color: progress >= (category == 'Urgent' ? 1.0 : 0.5)
                      ? activeColor
                      : inactiveColor,
                ),
              ),

              // Tutor Approved dot (only for Normal)
              if (category == 'Not Urgent') ...[
                _buildStepDot(
                  isActive: progress >= 0.5,
                  label: 'Tutor\nApproved',
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24),
                    color: progress >= 1.0 ? activeColor : inactiveColor,
                  ),
                ),
              ],

              // HOD Approved dot
              _buildStepDot(
                isActive: progress >= 1.0,
                label: 'HOD\nApproved',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              // ignore: deprecated_member_use
              backgroundColor: inactiveColor.withOpacity(0.3),
              color: activeColor,
            ),
          ),

          const SizedBox(height: 12),

          // Status text and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: $status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: activeColor,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot({
    required bool isActive,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            border: Border.all(
              color: isActive ? activeColor : inactiveColor,
              width: 3,
            ),
            shape: BoxShape.circle,
          ),
          child: isActive
              ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ),
      ],
    );
  }
}