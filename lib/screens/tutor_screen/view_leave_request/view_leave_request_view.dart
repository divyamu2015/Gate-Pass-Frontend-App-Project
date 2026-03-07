import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'view_leave_request_model.dart';
import 'view_leave_request_service.dart';

class ViewStudentLeaveRequest extends StatefulWidget {
  final int tutorId;
  const ViewStudentLeaveRequest({super.key, required this.tutorId});

  @override
  State<ViewStudentLeaveRequest> createState() =>
      _ViewStudentLeaveRequestState();
}

class _ViewStudentLeaveRequestState extends State<ViewStudentLeaveRequest> {
  late Future<List<LeaveRequestModel>> futureRequests;

  @override
  void initState() {
    super.initState();
    futureRequests = fetchTutorLeaveRequests(widget.tutorId);
    // print(futureRequests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Student Leave Requests"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),

      body: FutureBuilder<List<LeaveRequestModel>>(
        future: futureRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load data",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          final allRequests = snapshot.data ?? [];
          // print(allRequests);

          // Clean, normalize & match "Not Urgent"
          final requests = allRequests.where((item) {
            return item.category == "Not Urgent" || item.status == "Pending";
          }).toList();

          if (requests.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                  Text(
                    "No leave requests found",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return _leaveCard(req);
            },
          );
        },
      ),
    );
  }

  void _acceptRequest(LeaveRequestModel req) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Approve Request",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          content: Text(
            "Do you want to approve this request and forward it to HOD ${req.hodName}?",
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Approve",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    /// 🚀 API CALL — update status = "Tutor Approved"
    final success = await updateLeaveStatus(req.id, "Tutor Approved");

    if (success) {
      setState(() {
        req.status = "Tutor Approved";
      });

      _showForwardedDialog(req.hodName);
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update request")));
    }
  }

  Future<bool> updateAcceptLeaveStatus(int id, String status) async {
    final url = Uri.parse(
      "https://t3845w6p-8003.inc1.devtunnels.ms/userapp/tutor-requests/${widget.tutorId}/approve/$id/",
    );
    // print(url);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateLeaveStatus(int id, String status) async {
    final url = Uri.parse(
      "https://t3845w6p-8003.inc1.devtunnels.ms/userapp/tutor-requests/${widget.tutorId}/approve/$id/",
    );
    // print(url);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> rejectLeaveRequest(int id) async {
    final url = Uri.parse(
      "https://t3845w6p-8003.inc1.devtunnels.ms/userapp/tutor-requests/${widget.tutorId}/reject/$id/",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  void _rejectRequest(LeaveRequestModel req) async {
    final success = await rejectLeaveRequest(req.id);

    if (success) {
      setState(() {
        req.status = "Rejected by Tutor";
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request rejected successfully"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to reject request"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // 🌸 BEAUTIFUL CARD UI
  Widget _leaveCard(LeaveRequestModel req) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 Student name header
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Icon(Icons.perm_identity_outlined)
                  // Text(
                  //   (req.studentName.isNotEmpty ? req.studentName[0] : "?"),
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     color: Colors.deepPurple,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    req.studentName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            _line(),

            const SizedBox(height: 10),
            _infoRow("Department", req.departmentName),
            _infoRow("Course", req.courseName),
            _infoRow("HOD", req.hodName),
            _infoRow("Date", req.requestDate),
            _infoRow("Time", req.requestTime),
            _infoRow("Reason", req.reason),

            const SizedBox(height: 16),

            // ⭐ BUTTONS
            // ⭐ BUTTONS (Only show when pending)
            if (req.status == "Pending" || req.status == "Not Urgent") ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptRequest(req),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "ACCEPT",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rejectRequest(req),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "REJECT",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // ⭐ Status label when buttons are hidden
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: req.status == "Tutor Approved"
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  req.status,
                  style: TextStyle(
                    color: req.status == "Tutor Approved"
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey.shade300,
    );
  }

  void _showForwardedDialog(String hodName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Request Forwarded",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          content: Text(
            "This leave request has been forwarded to HOD $hodName.",
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              color: Colors.deepPurple.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF334155), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
