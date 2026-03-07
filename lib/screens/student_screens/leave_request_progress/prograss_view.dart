import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/qr_generation_screen/qr_generation.dart';

class LeaveRequestProcess extends StatefulWidget {
  final String status;
  final String category;
  final int studId;
  final String studName;
  final String department;
  final String courseName;
  final String tutorName;
  final String hodName;
  final String reason;
  final String requestDate;
  final String requestTime;
  final String qrCode;

  const LeaveRequestProcess({
     super.key,
    required this.status,
    required this.category,
    required this.studId,
    required this.studName,
    required this.department,
    required this.courseName,
    required this.tutorName,
    required this.hodName,
    required this.reason,
    required this.requestDate,
    required this.requestTime,
    required this.qrCode,
  });

  @override
  State<LeaveRequestProcess> createState() => _LeaveRequestProcessState();
}

class _LeaveRequestProcessState extends State<LeaveRequestProcess> {
  String? category;
  int? studId;
  String? studName;
  String? department;
  String? courseName;
  String? tutorName;
  String? hodName;
  String? reason;
  String? requestDate;
  String? requestTime;
  String? qrCode;
  @override
  void initState() {
    super.initState();
    category = widget.category;
    studId = widget.studId;
    studName = widget.studName;
    department = widget.department;
    courseName = widget.courseName;
    tutorName = widget.tutorName;
    hodName = widget.hodName;
    reason = widget.reason;
    requestDate = widget.requestDate;
    requestTime = widget.requestTime;
    qrCode = widget.qrCode;
  }
 
  double _getProgress() {
    if (widget.category == 'Not Urgent') {
      if (widget.status == 'Pending') return 0.0;
      if (widget.status == 'Tutor Approved') return 0.5;
      if (widget.status == 'HOD Approved') return 1.0;
    } else {
      if (widget.status == 'Pending') return 0.0;
      if (widget.status == 'HOD Approved') return 1.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    Color activeColor = Colors.green;
    Color inactiveColor = Colors.grey.shade400;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Request Process"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // === TIMELINE BOX ===
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Process Timeline',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  Text(
                    widget.category == 'Urgent' ? 'Urgent Request' : 'Normal Request',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 16),

                  // ===== ROW DOTS =====
                  Row(
                    children: [
                      _buildStepDot(
                        isActive: progress >= 0.0,
                        label: "Pending",
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 24),
                          color: progress >= (widget.category == 'Urgent' ? 1 : 0.5)
                              ? activeColor
                              : inactiveColor,
                        ),
                      ),
                      if (widget.category == 'Not Urgent') ...[
                        _buildStepDot(
                          isActive: progress >= 0.5,
                          label: "Tutor\nApproved",
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 24),
                            color: progress >= 1 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                      _buildStepDot(
                        isActive: progress >= 1,
                        label: "HOD\nApproved",
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    // ignore: deprecated_member_use
                    backgroundColor: inactiveColor.withOpacity(0.3),
                    color: activeColor,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: activeColor,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: activeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        const SizedBox(
          height: 30,
        ),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 118, 182, 235),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
               onPressed: (widget.status == "HOD Approved" || widget.status == "Leaved")
    ? () {
        if (widget.qrCode == "NO_QR_CODE") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("QR Code not generated yet"),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AutoQrGenerationScreen(
                studId: widget.studId,
                category: widget.category,
                courseName: widget.courseName,
                department: widget.department,
                hodName: widget.hodName,
                qrCode: widget.qrCode,
                reason: widget.reason,
                requestDate: widget.requestDate,
                requestTime: widget.requestTime,
                status: widget.status,
                studName: widget.studName,
                tutorName: widget.tutorName,
              );
            },
          ),
        );
      }
    : null,

                child: const Text(
                  'Your QRCODE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
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
              ? const Icon(Icons.check, size: 14, color: Colors.white)
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
