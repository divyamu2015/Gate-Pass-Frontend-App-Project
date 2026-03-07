class AttendanceResponse {
  final String message;
  final Attendance attendance;

  AttendanceResponse({required this.message, required this.attendance});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      message: json['message'],
      attendance: Attendance.fromJson(json['attendance']),
    );
  }
}

class Attendance {
  final int id;
  final int student;
  final String studentId;
  final String studentName;
  final String date;
  final String time;

  Attendance({
    required this.id,
    required this.student,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.time,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      student: json['student'],
      studentId: json['student_id'],
      studentName: json['student_name'],
      date: json['date'],
      time: json['time'],
    );
  }
}
