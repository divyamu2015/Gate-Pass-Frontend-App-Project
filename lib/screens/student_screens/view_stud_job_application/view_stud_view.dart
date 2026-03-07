import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_job_application/bloc/view_stud_bloc.dart';

class JobApplicationDetailsScreen extends StatefulWidget {
  const JobApplicationDetailsScreen({super.key, required this.studentId});
  final int studentId;

  @override
  State<JobApplicationDetailsScreen> createState() =>
      _JobApplicationDetailsScreenState();
}

class _JobApplicationDetailsScreenState
    extends State<JobApplicationDetailsScreen> {
  int? studentId;

  @override
  void initState() {
    super.initState();
    studentId = widget.studentId;
    context.read<ViewStudBloc>().add(
      ViewStudEvent.viewJobApplication(studentId: widget.studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9ECF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen(studId: studentId!);
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        //const BackButton(color: Colors.black),
        title: const Text(
          "My Job Applications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: BlocConsumer<ViewStudBloc, ViewStudState>(
        listener: (context, state) {
          // No controller usage since list view
        },

        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text("No Data")),

            loading: () => const Center(child: CircularProgressIndicator()),

            error: (err) => Center(
              child: Text(
                err,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),

            success: (applications) {
              if (applications.isEmpty) {
                return const Center(child: Text("No job applications found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final app = applications[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: _buildApplicationCard(app),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // -------------------------------------------------------
  // CARD UI
  // -------------------------------------------------------
  Widget _buildApplicationCard(app) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATUS BADGE
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              decoration: BoxDecoration(
                color: _getStatusColor(app.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                app.status,
                style: TextStyle(
                  color: _getStatusTextColor(app.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          _label("Student Name"),
          _value(app.studentName),

          const SizedBox(height: 14),

          _label("Job Title"),
          _value(app.jobTitle),

          const SizedBox(height: 14),

          // VIEW RESUME BUTTON
          GestureDetector(
            onTap: () {
              // OPEN PDF
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6FE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9E6FE),
                    child: Icon(Icons.picture_as_pdf, color: Color(0xFF468FF5)),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "View Resume",
                      style: TextStyle(
                        color: Color(0xFF2A3D52),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // APPLIED DATE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _label("Applied At"),
              Text(
                _formatDate(app.appliedAt),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A3D52),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------
  // Reusable label/value widgets
  //----------------------------------------
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
    );
  }

  Widget _value(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2A3D52),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  //----------------------------------------
  // Status Colors
  //----------------------------------------
  Color _getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return const Color(0xFFD6F5DD);
      case "Rejected":
        return const Color(0xFFF8D7DA);
      default:
        return const Color(0xFFFFF5CC); // Pending
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green.shade800;
      case "Rejected":
        return Colors.red.shade800;
      default:
        return const Color(0xFF8C6F1D);
    }
  }

  //----------------------------------------
  // Date formatting
  //----------------------------------------
  String _formatDate(DateTime dt) {
    return "${dt.day}-${dt.month}-${dt.year} "
        "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
