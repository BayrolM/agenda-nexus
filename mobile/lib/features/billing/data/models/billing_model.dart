import '../../domain/entities/billing_record.dart';

class BillingModel extends BillingRecord {
  const BillingModel({
    required super.id,
    required super.companyId,
    required super.reminderDate,
    super.amount,
    super.status,
    super.createdAt,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      id: json['id'] as String,
      companyId: json['company_id'] as String,
      reminderDate: DateTime.parse(json['reminder_date'] as String),
      amount: (json['amount'] as num?)?.toDouble(),
      status: BillingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BillingStatus.pending,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'reminder_date': reminderDate.toIso8601String().split('T')[0],
      'amount': amount,
      'status': status.name,
    };
  }
}
