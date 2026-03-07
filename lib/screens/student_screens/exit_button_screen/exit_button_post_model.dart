class LeaveRequest {
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
  final int student;
  final int tutor;
  final int hod;
  final int department;
  final int course;

  LeaveRequest({
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
    this.qrCode,
    required this.isLeaved,
    required this.createdAt,
    required this.student,
    required this.tutor,
    required this.hod,
    required this.department,
    required this.course,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      studentName: json['student_name'],
      tutorName: json['tutor_name'],
      hodName: json['hod_name'],
      departmentName: json['department_name'],
      courseName: json['course_name'],
      requestDate: json['request_date'],
      requestTime: json['request_time'],
      reason: json['reason'],
      category: json['category'],
      status: json['status'],
      forwardedToHod: json['forwarded_to_hod'],
      qrCode: json['qr_code'],
      isLeaved: json['is_leaved'],
      createdAt: json['created_at'],
      student: json['student'],
      tutor: json['tutor'],
      hod: json['hod'],
      department: json['department'],
      course: json['course'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'tutor_name': tutorName,
      'hod_name': hodName,
      'department_name': departmentName,
      'course_name': courseName,
      'request_date': requestDate,
      'request_time': requestTime,
      'reason': reason,
      'category': category,
      'status': status,
      'forwarded_to_hod': forwardedToHod,
      'qr_code': qrCode,
      'is_leaved': isLeaved,
      'created_at': createdAt,
      'student': student,
      'tutor': tutor,
      'hod': hod,
      'department': department,
      'course': course,
    };
  }
}

class LeaveRequestPostModel {
  final int student;
  final int tutor;
  final int hod;
  final int department;
  final int course;
  final String reason;
  final String category;
  final String status;

  LeaveRequestPostModel({
    required this.student,
    required this.tutor,
    required this.hod,
    required this.department,
    required this.course,
    required this.reason,
    required this.category,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'student': student,
        'tutor': tutor,
        'hod': hod,
        'department': department,
        'course': course,
        'reason': reason,
        'category': category,
        'status': status,
      };
}


