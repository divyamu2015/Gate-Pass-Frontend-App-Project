import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_attandence/view_attandence_model.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_attandence/view_attandence_service.dart';

class ViewAttendancePage extends StatefulWidget {
  final int tutorId;

  const ViewAttendancePage({super.key, required this.tutorId});

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  late Future<List<AttendanceModel>> attendances;

  @override
  void initState() {
    super.initState();
    attendances = fetchTodayAttendance(widget.tutorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EEF3),
        elevation: 0,
        title: const Text(
          "Today's Attendance",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<AttendanceModel>>(
        future: attendances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load attendance"));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.close,
                    color: Colors.red,),
                  ),
                Text("No attendance records found"),
              ],
            ));
          }

          return _buildElegantTable(data);
        },
      ),
    );
  }

  Widget _buildElegantTable(List<AttendanceModel> data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 179, 189, 236),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance Records",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // ----------- TABLE ------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  width: 1,
                  borderRadius: BorderRadius.circular(18),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                },
                children: [
                  _headerRow(),
                  ...data.map(_dataRow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- HEADER ROW ----------
  TableRow _headerRow() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A6B),
        borderRadius: BorderRadius.circular(18),
      ),
      children: const [
        _tableHeader("Student ID"),
        _tableHeader("Name"),
        _tableHeader("Time"),
      ],
    );
  }

  // ---------- DATA ROW ----------
  TableRow _dataRow(AttendanceModel m) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      children: [
        _tableCell(m.studentId),
        _tableCell(m.studentName),
        _tableCell(m.time),
      ],
    );
  }
}

// ---------- BEAUTIFUL CELLS ----------
class _tableHeader extends StatelessWidget {
  final String text;
  const _tableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _tableCell extends StatelessWidget {
  final String text;
  const _tableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
