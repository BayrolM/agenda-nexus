// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingRecordImpl _$$BillingRecordImplFromJson(Map<String, dynamic> json) =>
    _$BillingRecordImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      reminderDate: DateTime.parse(json['reminderDate'] as String),
      amount: (json['amount'] as num?)?.toDouble(),
      status:
          $enumDecodeNullable(_$BillingStatusEnumMap, json['status']) ??
          BillingStatus.pending,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BillingRecordImplToJson(_$BillingRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'reminderDate': instance.reminderDate.toIso8601String(),
      'amount': instance.amount,
      'status': _$BillingStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$BillingStatusEnumMap = {
  BillingStatus.pending: 'pending',
  BillingStatus.paid: 'paid',
  BillingStatus.overdue: 'overdue',
};
