class JobApplicationResponse {
  final int studentId;
  final List<JobApplication> applications;

  JobApplicationResponse({
    required this.studentId,
    required this.applications,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    var appsJson = json['applications'] as List<dynamic>;
    return JobApplicationResponse(
      studentId: json['student_id'],
      applications: appsJson
          .map((appJson) => JobApplication.fromJson(appJson))
          .toList(),
    );
  }
}

class JobApplication {
  final int id;
  final int student;
  final String studentName;
  final int job;
  final String jobTitle;
  final String resume;
  final String status;
  final DateTime appliedAt;

  JobApplication({
    required this.id,
    required this.student,
    required this.studentName,
    required this.job,
    required this.jobTitle,
    required this.resume,
    required this.status,
    required this.appliedAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      student: json['student'],
      studentName: json['student_name'],
      job: json['job'],
      jobTitle: json['job_title'],
      resume: json['resume'],
      status: json['status'],
      appliedAt: DateTime.parse(json['applied_at']),
    );
  }
}
