// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyServiceImpl _$$CompanyServiceImplFromJson(Map<String, dynamic> json) =>
    _$CompanyServiceImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
      name: json['name'] as String,
      url: json['url'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      apiKey: json['apiKey'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      monthlyCost: (json['monthlyCost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CompanyServiceImplToJson(
  _$CompanyServiceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'companyId': instance.companyId,
  'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
  'name': instance.name,
  'url': instance.url,
  'username': instance.username,
  'password': instance.password,
  'apiKey': instance.apiKey,
  'expirationDate': instance.expirationDate?.toIso8601String(),
  'monthlyCost': instance.monthlyCost,
  'notes': instance.notes,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$ServiceTypeEnumMap = {
  ServiceType.google: 'google',
  ServiceType.github: 'github',
  ServiceType.database: 'database',
  ServiceType.hosting: 'hosting',
  ServiceType.backend: 'backend',
  ServiceType.email: 'email',
  ServiceType.domain: 'domain',
  ServiceType.other: 'other',
};
