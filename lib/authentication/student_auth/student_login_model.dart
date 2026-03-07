class StudentLoginModel {
  final String message;
  final String role;
  final int userId;
  final String name;
  final String email;
  final String studentId;
  final int departmentId;
  final String department;
  final int courseId;
  final String course;

  StudentLoginModel({
    required this.message,
    required this.role,
    required this.userId,
    required this.name,
    required this.email,
    required this.studentId,
    required this.departmentId,
    required this.department,
    required this.courseId,
    required this.course,
  });

  factory StudentLoginModel.fromJson(Map<String, dynamic> json) {
    return StudentLoginModel(
      message: json['message'] ?? '',
      role: json['role'] ?? '',
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['student_id'] ?? '',
      departmentId: json['department_id'] ?? 0,
      department: json['department'] ?? '',
      courseId: json['course_id'] ?? 0,
      course: json['course'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'role': role,
      'user_id': userId,
      'name': name,
      'email': email,
      'student_id': studentId,
      'department_id': departmentId,
      'department': department,
      'course_id': courseId,
      'course': course,
    };
  }
}
