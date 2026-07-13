class Company {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? contactEmail;
  final String? contactPhone;
  final int? billingDay;
  final double? billingAmount;
  final String currency;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Company({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.contactEmail,
    this.contactPhone,
    this.billingDay,
    this.billingAmount,
    this.currency = 'COP',
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      billingDay: json['billing_day'] as int?,
      billingAmount: (json['billing_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'MXN',
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
