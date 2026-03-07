class ApplicationModel {
  final int id;
  final int student;
  final String studentName;
  final int job;
  final String jobTitle;
  final String company;     // NEW FIELD
  final String resume;
  final String status;
  final String appliedAt;

  ApplicationModel({
    required this.id,
    required this.student,
    required this.studentName,
    required this.job,
    required this.jobTitle,
    required this.company,  // NEW FIELD
    required this.resume,
    required this.status,
    required this.appliedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json["id"],
      student: json["student"],
      studentName: json["student_name"],
      job: json["job"],
      jobTitle: json["job_title"],
      company: json["company"],    // NEW FIELD
      resume: json["resume"],
      status: json["status"],
      appliedAt: json["applied_at"],
    );
  }
}
