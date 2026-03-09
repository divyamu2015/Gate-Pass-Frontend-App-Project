// job_screens.dart
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gate_pass_project/screens/student_screens/view_job_details/get_job_details.dart';
import 'package:http/http.dart' as http;

/// LOCAL FALLBACK IMAGE (uploaded)
const String localFallbackImagePath =
    '/mnt/data/da41f8b6-58ef-4b5a-a8f3-01049ed43fb8.png';

/// ------------------------- MODELS -------------------------
// class Company {
//   final int id;
//   final String name;
//   final String logo;
//   final String description;

//   Company({
//     required this.id,
//     required this.name,
//     required this.logo,
//     required this.description,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       logo: json['logo'] as String? ?? '',
//       description: json['description'] as String? ?? '',
//     );
//   }
// }

// class Job {
//   final int id;
//   final String title;
//   final String logo;
//   final String jobType;
//   final String description;
//   final String place;
//   final String date;
//   final String salary;
//   final String responsibilities;
//   final String qualifications;
//   final int vacancy;
//   final int company;
//   final int departmentId;

//   Job({
//     required this.id,
//     required this.title,
//     required this.logo,
//     required this.jobType,
//     required this.description,
//     required this.place,
//     required this.date,
//     required this.salary,
//     required this.responsibilities,
//     required this.qualifications,
//     required this.vacancy,
//     required this.company,
//     required this.departmentId,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['id'] as int,
//       title: (json['title'] as String?) ?? 'No Title',
//       logo: (json['logo'] as String?) ?? '',
//       jobType: (json['job_type'] as String?) ?? 'N/A',
//       description: (json['description'] as String?) ?? '',
//       place: (json['place'] as String?) ?? 'N/A',
//       date: (json['date'] as String?) ?? 'N/A',
//       salary: (json['salary'] as String?) ?? 'N/A',
//       responsibilities: (json['responsibilities'] as String?) ?? '',
//       qualifications: (json['qualifications'] as String?) ?? '',
//       vacancy: (json['vacancy'] is int) ? json['vacancy'] as int : int.tryParse('${json['vacancy']}') ?? 0,
//       company: (json['company'] is int) ? json['company'] as int : int.tryParse('${json['company']}') ?? 0,
//       departmentId: (json['department_id'] is int) ? json['department_id'] as int : int.tryParse('${json['department_id']}') ?? 0,
//     );
//   }
// }

// class CompanyJobsResponse {
//   final Company company;
//   final List<Job> jobs;

//   CompanyJobsResponse({
//     required this.company,
//     required this.jobs,
//   });

//   factory CompanyJobsResponse.fromJson(Map<String, dynamic> json) {
//     final compJson = json['company'] as Map<String, dynamic>? ?? {};
//     final jobsJson = json['jobs'] as List<dynamic>? ?? [];
//     return CompanyJobsResponse(
//       company: Company.fromJson(compJson),
//       jobs: jobsJson.map((e) => Job.fromJson(e as Map<String, dynamic>)).toList(),
//     );
//   }
// }

/// ------------------------- JOBS LIST SCREEN -------------------------
class JobsListScreen extends StatefulWidget {
  final int companyId;
  final String companyName;
  final String companyLogo;
  final int studentId;

  const JobsListScreen({
    super.key,
    required this.companyId,
    required this.companyName,
    required this.companyLogo,
    required this.studentId,
  });

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  bool isLoading = false;
  String? error;
  CompanyJobsResponse? responseModel;
  bool showDetails = false;
  File? _selectedResume;
  Map<int, bool> expandedJobs = {};
  int? studentId;

  @override
  void initState() {
    super.initState();
    studentId = widget.studentId;
   // print('JobsListScreen===$studentId');
    _fetchCompanyJobs();
  }

  Future<void> _fetchCompanyJobs() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final url =
        'https://417sptdw-8003.inc1.devtunnels.ms/userapp/job_by_company/${widget.companyId}/';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body) as Map<String, dynamic>;
        final parsed = CompanyJobsResponse.fromJson(decoded);
        setState(() {
          responseModel = parsed;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Server returned ${res.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedResume = File(result.files.single.path!);
      });
    }
  }

  Future<void> _applyForJob(int studentId, int jobId, File resumeFile) async {
    final uri = Uri.parse(
      "https://417sptdw-8003.inc1.devtunnels.ms/userapp/job-applications/",
    );

    final request = http.MultipartRequest("POST", uri);

    request.fields["student"] = studentId.toString();
    request.fields["job"] = jobId.toString();

    request.files.add(
      await http.MultipartFile.fromPath("resume", resumeFile.path),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Application submitted!")),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildHeader() {
   // double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;

    // decides image provider (network or local fallback)
    ImageProvider logoImage;
    final apiLogo = widget.companyLogo;
    if (apiLogo.isNotEmpty &&
        (apiLogo.startsWith('http') || apiLogo.startsWith('/'))) {
      // if API provides relative path, try network by prefixing base
      final url = apiLogo.startsWith('http')
          ? apiLogo
          : 'https://417sptdw-8003.inc1.devtunnels.ms$apiLogo';
      logoImage = NetworkImage(url);
    } else {
      logoImage = FileImage(File(localFallbackImagePath));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfff6e6ff), Color(0xfffdeef0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color(0xFF5B4FE9),
                          Color(0xFFF178B6),
                          Color(0xFF3FE0C5),
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 80.0)),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🌸 BEAUTIFUL SMALL CIRCLE LOGO
          Center(
            child: Container(
              width: w * 0.7, // 🔥 small & cute
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                image: DecorationImage(image: logoImage, fit: BoxFit.cover),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbf7fb),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey[800],
        title: const Text(
          'Job Openings',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCompanyJobs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 30),
                children: [
                  _buildHeader(),
                  if (responseModel == null || responseModel!.jobs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'No open positions',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    )
                  else
                    ...responseModel!.jobs.map((job) => _jobListTile(job)),
                ],
              ),
      ),
    );
  }

  Widget _section(String title, String content, {int? vacancy}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (vacancy != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$vacancy Vacancies',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  Future<void> _showApplyDialog(int jobId,int studentId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upload your resume'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: const Text('Choose Resume File'),
                onPressed: _pickResume,
              ),
              const SizedBox(height: 12),
              if (_selectedResume != null)
                Text('Selected: ${_selectedResume!.path.split('/').last}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_selectedResume != null) {
                  Navigator.of(context).pop();

                  // 🔥 Call API
                  await _applyForJob(studentId, jobId, _selectedResume!);

                  setState(() {
                    _selectedResume = null;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a resume file'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _jobListTile(Job job) {
    // 🔥 each job has its own expanded state
    final isExpanded = expandedJobs[job.id] ?? false;

    // ignore: unused_local_variable
    final logoUrl = job.logo.isNotEmpty
        ? 'https://417sptdw-8003.inc1.devtunnels.ms${job.logo}'
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xfff6e6ff), Color(0xffe8f1ff)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff3d3d52),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _smallTag(
                          Icons.work,
                          job.jobType,
                          Colors.purple.shade100,
                        ),
                        _smallTag(Icons.place, job.place, Colors.cyan.shade100),
                        _smallTag(
                          Icons.attach_money,
                          job.salary,
                          Colors.green.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
            ],
          ),

          const SizedBox(height: 12),

          // 🔽 Expand / Collapse toggle
          GestureDetector(
            onTap: () {
              setState(() {
                expandedJobs[job.id] = !isExpanded;
              });
            },
            child: Container(
              width: 35,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 28,
                color: Colors.purple,
              ),
            ),
          ),

          // 🔽 Animated Details
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isExpanded
                ? Column(
                    key: ValueKey("${job.id}_expanded"),
                    children: [
                      _section("Job Description", job.description),
                      _section("Responsibilities", job.responsibilities),
                      _section(
                        "Qualifications",
                        job.qualifications,
                        vacancy: job.vacancy,
                      ),
                    ],
                  )
                : const SizedBox(key: ValueKey("closed"), height: 0),
          ),

          const SizedBox(height: 16),

          // 🔥 Apply Now button (now works always)
          ElevatedButton(
            onPressed: () => _showApplyDialog(job.id,studentId!),
            child: const Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  Widget _smallTag(IconData icon, String text, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

/// ------------------------- JOB DETAIL PAGE -------------------------
class JobDetailPage extends StatefulWidget {
  final String companyName;
  final String companyLogo;
  final Job job;

  const JobDetailPage({
    super.key,
    required this.companyName,
    required this.companyLogo,
    required this.job,
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  // ignore: unused_field
  File? _selectedResume;
  bool uploading = false;

  // ignore: unused_element
  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedResume = File(result.files.single.path!);
      });
    }
  }

  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final jobLogoUrl = job.logo.isNotEmpty
        ? 'https://417sptdw-8003.inc1.devtunnels.ms${job.logo}'
        : null;
    final companyLogoUrl = widget.companyLogo.isNotEmpty
        ? 'https://417sptdw-8003.inc1.devtunnels.ms${widget.companyLogo}'
        : null;

    final headerImage = (jobLogoUrl != null)
        ? NetworkImage(jobLogoUrl)
        : (companyLogoUrl != null)
        ? NetworkImage(companyLogoUrl)
        : FileImage(File(localFallbackImagePath)) as ImageProvider;

    return Scaffold(
      backgroundColor: const Color(0xfffbf7fb),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey[800],
        title: Text(
          widget.companyName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Container(
      //   margin: const EdgeInsets.symmetric(horizontal: 36),
      //   child: ElevatedButton(
      //     onPressed: _showApplyDialog,
      //     style: ElevatedButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(vertical: 14),
      //       backgroundColor: const Color(0xffd9b6ff),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       elevation: 8,
      //     ),
      //     child: const Center(
      //       child: Text(
      //         'Apply Now',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 16,
      //           fontWeight: FontWeight.w800,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // big header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xfff6e6ff), Color(0xfff6f6ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: headerImage,
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  widget.companyName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4a4a6a),
                  ),
                ),
              ],
            ),
          ),

          // Title & underline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 4,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // chips row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _chip(Icons.work, job.jobType, Colors.purple.shade100),
                _chip(Icons.place, job.place, Colors.cyan.shade100),
                _chip(Icons.calendar_today, job.date, Colors.pink.shade100),
                _chip(Icons.attach_money, job.salary, Colors.green.shade100),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // sections
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
