import 'package:flutter/material.dart';

// Simple model for viewing (can also reuse your existing LeaveDetails)

/// VIEW-ONLY SCREEN (no bloc, no service)
class AutoQrGenerationScreen extends StatefulWidget {
  const AutoQrGenerationScreen({
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

  @override
  State<AutoQrGenerationScreen> createState() => _AutoQrGenerationScreenState();
}

class _AutoQrGenerationScreenState extends State<AutoQrGenerationScreen> {
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

  @override
  Widget build(BuildContext context) {
   
    // backend returns relative path, build full URL
    const baseUrl = 'https://417sptdw-8003.inc1.devtunnels.ms';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF8FBFF),
        foregroundColor: Colors.black,
        title: const Text(
          'Leave Request Details',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student / Department / Course
           

            const SizedBox(height: 24),

            // QR code section
            if (widget.qrCode.isNotEmpty) ...[
               Text(
                '${widget.studName} QR Code',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Center(
                child: Image.network(
                  '$baseUrl${widget.qrCode}',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Back button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: const Color.fromARGB(255, 118, 182, 235),
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


