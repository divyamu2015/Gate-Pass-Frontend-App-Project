class TutorLoginModel {
  final String message;
  final String role;
  final int userId;
  final String name;
  final String email;
  final String tutorId;
  final int hodId;
  final String hodName;
  final int departmentId;
  final String department;

  TutorLoginModel({
    required this.message,
    required this.role,
    required this.userId,
    required this.name,
    required this.email,
    required this.tutorId,
    required this.hodId,
    required this.hodName,
    required this.departmentId,
    required this.department,
  });

  factory TutorLoginModel.fromJson(Map<String, dynamic> json) {
    return TutorLoginModel(
      message: json['message'] ?? '',
      role: json['role'] ?? '',
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      tutorId: json['tutor_id'] ?? '',
      hodId: json['hod_id'] ?? 0,
      hodName: json['hod_name'] ?? '',
      departmentId: json['department_id'] ?? 0,
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'role': role,
      'user_id': userId,
      'name': name,
      'email': email,
      'tutor_id': tutorId,
      'hod_id': hodId,
      'hod_name': hodName,
      'department_id': departmentId,
      'department': department,
    };
  }
}
