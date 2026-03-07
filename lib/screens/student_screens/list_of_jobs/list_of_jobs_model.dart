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

  // A factory constructor to create a CompanyModel instance from a JSON map.
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
