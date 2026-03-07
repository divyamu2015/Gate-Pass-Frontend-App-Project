class CompanyResponseModel {
  final CompanyModel company;
  final List<JobModel> jobs;

  CompanyResponseModel({
    required this.company,
    required this.jobs,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      company: CompanyModel.fromJson(json['company']),
      jobs: (json['jobs'] as List<dynamic>)
          .map((job) => JobModel.fromJson(job))
          .toList(),
    );
  }
}

class CompanyModel {
  final int id;
  final String name;
  final String logo;
  final String description;

  CompanyModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class JobModel {
  final int id;
  final String title;
  final String logo;
  final String jobType;
  final String description;
  final String place;
  final String date;
  final String salary;
  final String responsibilities;
  final String qualifications;
  final int vacancy;
  final int company;
  final int departmentId;

  JobModel({
    required this.id,
    required this.title,
    required this.logo,
    required this.jobType,
    required this.description,
    required this.place,
    required this.date,
    required this.salary,
    required this.responsibilities,
    required this.qualifications,
    required this.vacancy,
    required this.company,
    required this.departmentId,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      logo: json['logo'] ?? '',
      jobType: json['job_type'] ?? '',
      description: json['description'] ?? '',
      place: json['place'] ?? '',
      date: json['date'] ?? '',
      salary: json['salary'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      qualifications: json['qualifications'] ?? '',
      vacancy: json['vacancy'] ?? 0,
      company: json['company'] ?? 0,
      departmentId: json['department_id'] ?? 0,
    );
  }
}
