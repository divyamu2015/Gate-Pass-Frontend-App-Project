import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/tutor_screen/tutor_home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_appli_service.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_applica_model.dart';

class ApplicationDetailsPage extends StatefulWidget {
  final int tutorId;
  final ApplicationModel model;

  const ApplicationDetailsPage({
    super.key,
    required this.tutorId,
    required this.model,
  });

  @override
  State<ApplicationDetailsPage> createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage> {
  late ApplicationModel selected;

  @override
  void initState() {
    super.initState();
    selected = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(255, 243, 238, 243);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Application Details',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: _detailsCard(selected),
    );
  }

  Widget _detailsCard(ApplicationModel app) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 179, 189, 236),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(app.studentName,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            Text(app.company,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),

            const SizedBox(height: 24),
            const Divider(color: Color.fromARGB(255, 185, 135, 173)),
            const SizedBox(height: 16),

            _row("Job Title", app.jobTitle),
            const SizedBox(height: 12),

                _row("Job Title", app.jobTitle),
            const SizedBox(height: 12),


            
            _row("Resume", "Tap to View"),
            const SizedBox(height: 24),

            _resumeButton(app.resume),
            const SizedBox(height: 24),

            const Divider(color: Color.fromARGB(255, 185, 135, 173)),
            const SizedBox(height: 16),

            _actionButtons(app),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFF9CA3AF), fontSize: 14))),
        Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _resumeButton(String resume) {
    return ElevatedButton.icon(
      onPressed: () {
        final url =
            Uri.parse("https://417sptdw-8003.inc1.devtunnels.ms$resume");
        launchUrl(url, mode: LaunchMode.externalApplication);
      },
      icon: const Icon(Icons.description_outlined),
      label: const Text("View Resume"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F2A6B),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // ---------------- ACCEPT / REJECT BUTTONS ----------------
  Widget _actionButtons(ApplicationModel app) {
    return Row(
      children: [
        // REJECT BUTTON
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final ok = await rejectApplication(app.id,widget.tutorId);
              if (ok) {
                // Navigate immediately to dashboard
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorDashboard(
                      tutorName: app.studentName,
                      tutorId: widget.tutorId,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.close),
            label: const Text("Reject"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // ACCEPT BUTTON
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              final ok = await approveApplication(app.id, widget.tutorId);
              if (ok) {
                // Navigate immediately to dashboard
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (_) => TutorDashboard(
                      tutorName: app.studentName,
                      tutorId: widget.tutorId,
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check),
            label: const Text("Accept"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension AppCopy on ApplicationModel {
  ApplicationModel copyWith({String? status}) {
    return ApplicationModel(
      id: id,
      student: student,
      studentName: studentName,
      job: job,
      jobTitle: jobTitle,
      company: company,
      resume: resume,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}
