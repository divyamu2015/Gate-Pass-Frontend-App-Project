class LeaveDetails {
  final int id;
  final String studentName;
  final String tutorName;
  final String hodName;
  final String departmentName;
  final String courseName;
  final String? requestDate;
  final String? requestTime;
  final String reason;
  final String category;
  final String status;
  final bool forwardedToHod;
  final String? qrCode;
  final bool isLeaved;
  final String createdAt;

  LeaveDetails({
    required this.id,
    required this.studentName,
    required this.tutorName,
    required this.hodName,
    required this.departmentName,
    required this.courseName,
    this.requestDate,
    this.requestTime,
    required this.reason,
    required this.category,
    required this.status,
    required this.forwardedToHod,
    required this.qrCode,
    required this.isLeaved,
    required this.createdAt,
  });

  factory LeaveDetails.fromJson(Map<String, dynamic> json) {
    return LeaveDetails(
       id: json['id'] ?? 0,
      studentName: json['student_name'] ?? "",
      tutorName: json['tutor_name'] ?? "",
      hodName: json['hod_name'] ?? "",
      departmentName: json['department_name'] ?? "",
      courseName: json['course_name'] ?? "",
      requestDate: json['request_date'] as String?,
      requestTime: json['request_time'] as String?,
      reason: json['reason'] ?? "",
      category: json['category'] ?? "",
      status: json['status'] ?? "",
      forwardedToHod: json['forwarded_to_hod'] ?? false,
      qrCode: json['qr_code'] as String?,   // can be null
      isLeaved: json['is_leaved'] ?? false,
      createdAt: json['created_at'] ?? "",
    );
  }
}
