class StudentModel {
  final int id;
  final String name;
  final String gender;
  final String email;
  final String phone;
  final String address;
  final String dob;
  final int year;
  final String supply;
  final String batch;
  final String studentId;
  final String registerNumber;
  final String rollNumber;
  final String role;
  final String image;
  final int tutor;
  final int hod;
  final int department;
  final int course;

  StudentModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phone,
    required this.address,
    required this.dob,
    required this.year,
    required this.supply,
    required this.batch,
    required this.studentId,
    required this.registerNumber,
    required this.rollNumber,
    required this.role,
    required this.image,
    required this.tutor,
    required this.hod,
    required this.department,
    required this.course,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      year: json['year'] ?? 0,
      supply: json['supply'] ?? '',
      batch: json['batch'] ?? '',
      studentId: json['student_id'] ?? '',
      registerNumber: json['register_number'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      tutor: json['tutor'] ?? 0,
      hod: json['hod'] ?? 0,
      department: json['department'] ?? 0,
      course: json['course'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'phone': phone,
      'address': address,
      'dob': dob,
      'year': year,
      'supply': supply,
      'batch': batch,
      'student_id': studentId,
      'register_number': registerNumber,
      'roll_number': rollNumber,
      'role': role,
      'image': image,
      'tutor': tutor,
      'hod': hod,
      'department': department,
      'course': course,
    };
  }
}
