class Company {
  int id;
  String name;
  String logo;
  String description;

  Company({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
    };
  }
}

class Job {
  int id;
  String title;
  String logo;
  String jobType;
  String description;
  String place;
  String date;
  String salary;
  String responsibilities;
  String qualifications;
  int vacancy;
  int company;
  int departmentId;

  Job({
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

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      logo: json['logo'],
      jobType: json['job_type'],
      description: json['description'],
      place: json['place'],
      date: json['date'],
      salary: json['salary'],
      responsibilities: json['responsibilities'],
      qualifications: json['qualifications'],
      vacancy: json['vacancy'],
      company: json['company'],
      departmentId: json['department_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'logo': logo,
      'job_type': jobType,
      'description': description,
      'place': place,
      'date': date,
      'salary': salary,
      'responsibilities': responsibilities,
      'qualifications': qualifications,
      'vacancy': vacancy,
      'company': company,
      'department_id': departmentId,
    };
  }
}

class CompanyJobsResponse {
  Company company;
  List<Job> jobs;

  CompanyJobsResponse({
    required this.company,
    required this.jobs,
  });

  factory CompanyJobsResponse.fromJson(Map<String, dynamic> json) {
    return CompanyJobsResponse(
      company: Company.fromJson(json['company']),
      jobs: (json['jobs'] as List<dynamic>).map((jobJson) => Job.fromJson(jobJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company.toJson(),
      'jobs': jobs.map((job) => job.toJson()).toList(),
    };
  }
}
