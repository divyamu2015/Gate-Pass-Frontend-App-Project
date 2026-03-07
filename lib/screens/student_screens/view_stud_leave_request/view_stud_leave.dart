import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_pass_project/screens/student_screens/home_page/home_page.dart';
import 'package:gate_pass_project/screens/student_screens/leave_request_progress/prograss_view.dart';
import 'package:gate_pass_project/screens/student_screens/view_stud_leave_request/bloc/stud_view_bloc.dart';

class LeaveRequestDetailsPage extends StatefulWidget {
  const LeaveRequestDetailsPage({
    super.key,
    required this.studentId,
    // required this.data,
  });
  final int studentId;
  @override
  State<LeaveRequestDetailsPage> createState() =>
      _LeaveRequestDetailsPageState();
}

class _LeaveRequestDetailsPageState extends State<LeaveRequestDetailsPage> {
  int? studeId;

  @override
  void initState() {
    super.initState();
    studeId = widget.studentId;
    context.read<StudViewBloc>().add(
      StudViewEvent.viewLeaveRequest(studentId: widget.studentId),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return HomeScreen(studId: studeId!,);
          },));
        }, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFF),
        foregroundColor: Colors.black,
        title: const Text(
          'Leave Request Details',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: BlocConsumer<StudViewBloc, StudViewState>(
        listener: (context, state) {
          state.maybeWhen(error: (error) => showError(error), orElse: () {});
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            success: (data) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 170, top: 5),
                    child: Row(
                      // crossAxisAlignment: cross,
                      children: [
                        Text(
                          'Category:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: 'category'.toLowerCase() == 'urgent'
                                ? const Color(0xFFFFCDD2)
                                : const Color(0xFFFFD900),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Text(
                            data.category,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Student / Department / Course
                  _InfoCard(
                    background: const Color(0xFFE5F3FF),
                    children: [
                      _labelValueRow('Student Name: ', data.studentName),
                      const Divider(height: 32),
                      _labelValueRow('Department:', data.departmentName),
                      const Divider(height: 32),
                      _labelValueRow('Course:', data.courseName),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tutor / HOD
                  _InfoCard(
                    background: const Color(0xFFF7E8FF),
                    children: [
                      Row(
                        children: [
                          _roundIcon(Icons.school),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tutor Name: ${data.tutorName}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _roundIcon(Icons.work),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'HOD Name: ${data.hodName}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Requested date / time
                  _InfoCard(
                    background: const Color(0xFFE5FAFF),
                    children: [
                      Row(
                        children: [
                          _roundIcon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Requested Date: ${data.requestDate}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _roundIcon(Icons.access_time),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Requested Time: ${data.requestTime}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Reason + Category
                  _InfoCard(
                    background: const Color(0xFFFFF0CF),
                    children: [
                      Text(
                        'Reason:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.reason,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0047B3),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                       ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 137, 180, 245),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                         onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen(studId: studeId!);
                          },
                        ),
                      ), child: Text('Back')),
                      const SizedBox(width: 120),
                       ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 137, 180, 245),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                        onPressed: () {
  if (studeId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student ID missing"),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // ---- CRITICAL FIX: Handle null QR code safely ----
  final safeQrCode = data.qrCode ?? "NO_QR_CODE";

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return LeaveRequestProcess(
          studId: studeId!,
          category: data.category,
          status: data.status,
          courseName: data.courseName,
          department: data.departmentName,
          hodName: data.hodName,
          reason: data.reason,
          qrCode: safeQrCode,   // ✅ SAFE (never null now)
          requestDate: data.requestDate ?? "N/A",
          requestTime: data.requestTime ?? "N/A",
          studName: data.studentName,
          tutorName: data.tutorName,
        );
      },
    ),
  );
},

                        child: Text('View Status'),
                      ),
                    ],
                  ),
                  // Back button
                  // SizedBox(
                  //   height: 56,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF0047B3),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(28),
                  //       ),
                  //     ),
                  //     onPressed: () => Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) {
                  //           return HomeScreen(studId: studeId!);
                  //         },
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Back',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row _labelValueRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Color(0xFF777777)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0047B3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _roundIcon(IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black87, size: 24),
    );
  }
}

// Simple reusable card with rounded corners
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children, required this.background});

  final List<Widget> children;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
