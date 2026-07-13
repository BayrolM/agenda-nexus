import '../../domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.id,
    required super.userId,
    required super.name,
    super.description,
    super.contactEmail,
    super.contactPhone,
    super.billingDay,
    super.billingAmount,
    super.currency,
    super.notes,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      billingDay: json['billing_day'] as int?,
      billingAmount: (json['billing_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'COP',
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
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
      'user_id': userId,
      'name': name,
      'description': description,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'billing_day': billingDay,
      'billing_amount': billingAmount,
      'currency': currency,
      'notes': notes,
      'is_active': isActive,
    };
  }
}
