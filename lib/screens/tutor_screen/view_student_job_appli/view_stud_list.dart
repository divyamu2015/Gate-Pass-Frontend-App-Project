import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_appli_service.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_applica_model.dart';
import 'package:gate_pass_project/screens/tutor_screen/view_student_job_appli/view_stud_jonappli.dart';


class ApplicationListPage extends StatefulWidget {
  final int tutorId;
  const ApplicationListPage({super.key, required this.tutorId});

  @override
  State<ApplicationListPage> createState() => _ApplicationListPageState();
}

class _ApplicationListPageState extends State<ApplicationListPage> {
  late Future<List<ApplicationModel>> appsFuture;

  @override
  void initState() {
    super.initState();
    appsFuture = fetchAppliedStudents(widget.tutorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Student Job Applications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),

      body: FutureBuilder<List<ApplicationModel>>(
        future: appsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading applications"));
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.close,
                    color: Colors.red,),
                  ),
                Text("No applications found"),
              ],
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final app = list[index];

              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text(
                    app.jobTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Student: ${app.studentName}\nCompany: ${app.company}",
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplicationDetailsPage(
                          model: app,
                          tutorId: widget.tutorId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
