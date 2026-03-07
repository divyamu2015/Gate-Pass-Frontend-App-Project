class LeaveRequestModel {
  final int id;
  final String studentName;
  final String tutorName;
  final String hodName;
  final String departmentName;
  final String courseName;
  final String requestDate;
  final String requestTime;
  final String reason;
  final String category;
  String status;
  final bool forwardedToHod;
  final String? qrCode;
  final bool isLeaved;
  final String createdAt;
  final int student;
  final int tutor;
  final int hod;
  final int department;
  final int course;

  LeaveRequestModel({
    required this.id,
    required this.studentName,
    required this.tutorName,
    required this.hodName,
    required this.departmentName,
    required this.courseName,
    required this.requestDate,
    required this.requestTime,
    required this.reason,
    required this.category,
    required this.status,
    required this.forwardedToHod,
    required this.qrCode,
    required this.isLeaved,
    required this.createdAt,
    required this.student,
    required this.tutor,
    required this.hod,
    required this.department,
    required this.course,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json["id"] ?? 0,
      studentName: json["student_name"] ?? "",
      tutorName: json["tutor_name"] ?? "",
      hodName: json["hod_name"] ?? "",
      departmentName: json["department_name"] ?? "",
      courseName: json["course_name"] ?? "",
      
      // 🛠 FIX: avoid null crash
      requestDate: json["request_date"] ?? "",
      requestTime: json["request_time"] ?? "",
      reason: json["reason"] ?? "",
      category: json["category"] ?? "",
      status: json["status"] ?? "Pending",
      
      forwardedToHod: json["forwarded_to_hod"] ?? false,
      qrCode: json["qr_code"],  // nullable, OK
      isLeaved: json["is_leaved"] ?? false,
      createdAt: json["created_at"] ?? "",
      
      student: json["student"] ?? 0,
      tutor: json["tutor"] ?? 0,
      hod: json["hod"] ?? 0,
      department: json["department"] ?? 0,
      course: json["course"] ?? 0,
    );
  }
}
