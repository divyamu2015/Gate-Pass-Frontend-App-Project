class AttendanceModel {
  final int id;
  final int student;
  final String studentId;
  final String studentName;
  final String date;
  final String time;

  AttendanceModel({
    required this.id,
    required this.student,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.time,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json["id"],
      student: json["student"],
      studentId: json["student_id"],
      studentName: json["student_name"],
      date: json["date"],
      time: json["time"],
    );
  }
}
