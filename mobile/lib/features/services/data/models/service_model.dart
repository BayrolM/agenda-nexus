import '../../domain/entities/company_service.dart';

class ServiceModel extends CompanyService {
  const ServiceModel({
    required super.id,
    required super.companyId,
    required super.serviceType,
    required super.name,
    super.url,
    super.username,
    super.password,
    super.apiKey,
    super.expirationDate,
    super.monthlyCost,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      serviceType: ServiceType.values.firstWhere(
        (e) => e.name == json['service_type'],
        orElse: () => ServiceType.other,
      ),
      name: json['service_name'] as String,
      url: json['url'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      apiKey: json['api_key'] as String?,
      expirationDate: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'] as String)
          : null,
      monthlyCost: (json['monthly_cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'service_type': serviceType.name,
      'service_name': name,
      'url': url,
      'username': username,
      'password': password,
      'api_key': apiKey,
      'expiration_date': expirationDate?.toIso8601String().split('T')[0],
      'monthly_cost': monthlyCost,
      'notes': notes,
    };
  }
}
