class Student {
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
  final String tutorName;
  final String hodName;
  final String departmentName;
  final String courseName;

  Student({
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
    required this.tutorName,
    required this.hodName,
    required this.departmentName,
    required this.courseName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      year: json['year'],
      supply: json['supply'] ?? '',
      batch: json['batch'] ?? '',
      studentId: json['student_id'] ?? '',
      registerNumber: json['register_number'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      tutor: json['tutor'],
      hod: json['hod'],
      department: json['department'],
      course: json['course'],
      tutorName: json['tutor_name'] ?? '',
      hodName: json['hod_name'] ?? '',
      departmentName: json['department_name'] ?? '',
      courseName: json['course_name'] ?? '',
    );
  }
}
