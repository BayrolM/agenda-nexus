enum BillingStatus {
  pending,
  paid,
  overdue,
}

class BillingRecord {
  final String id;
  final String companyId;
  final DateTime reminderDate;
  final double? amount;
  final BillingStatus status;
  final DateTime? createdAt;

  const BillingRecord({
    required this.id,
    required this.companyId,
    required this.reminderDate,
    this.amount,
    this.status = BillingStatus.pending,
    this.createdAt,
  });

  factory BillingRecord.fromJson(Map<String, dynamic> json) {
    return BillingRecord(
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
