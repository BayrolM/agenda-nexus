// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompanyService _$CompanyServiceFromJson(Map<String, dynamic> json) {
  return _CompanyService.fromJson(json);
}

/// @nodoc
mixin _$CompanyService {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  ServiceType get serviceType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get apiKey => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  double? get monthlyCost => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CompanyService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyServiceCopyWith<CompanyService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyServiceCopyWith<$Res> {
  factory $CompanyServiceCopyWith(
    CompanyService value,
    $Res Function(CompanyService) then,
  ) = _$CompanyServiceCopyWithImpl<$Res, CompanyService>;
  @useResult
  $Res call({
    String id,
    String companyId,
    ServiceType serviceType,
    String name,
    String? url,
    String? username,
    String? password,
    String? apiKey,
    DateTime? expirationDate,
    double? monthlyCost,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CompanyServiceCopyWithImpl<$Res, $Val extends CompanyService>
    implements $CompanyServiceCopyWith<$Res> {
  _$CompanyServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? serviceType = null,
    Object? name = null,
    Object? url = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? apiKey = freezed,
    Object? expirationDate = freezed,
    Object? monthlyCost = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            companyId: null == companyId
                ? _value.companyId
                : companyId // ignore: cast_nullable_to_non_nullable
                      as String,
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as ServiceType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            password: freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String?,
            apiKey: freezed == apiKey
                ? _value.apiKey
                : apiKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            expirationDate: freezed == expirationDate
                ? _value.expirationDate
                : expirationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            monthlyCost: freezed == monthlyCost
                ? _value.monthlyCost
                : monthlyCost // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyServiceImplCopyWith<$Res>
    implements $CompanyServiceCopyWith<$Res> {
  factory _$$CompanyServiceImplCopyWith(
    _$CompanyServiceImpl value,
    $Res Function(_$CompanyServiceImpl) then,
  ) = __$$CompanyServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String companyId,
    ServiceType serviceType,
    String name,
    String? url,
    String? username,
    String? password,
    String? apiKey,
    DateTime? expirationDate,
    double? monthlyCost,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CompanyServiceImplCopyWithImpl<$Res>
    extends _$CompanyServiceCopyWithImpl<$Res, _$CompanyServiceImpl>
    implements _$$CompanyServiceImplCopyWith<$Res> {
  __$$CompanyServiceImplCopyWithImpl(
    _$CompanyServiceImpl _value,
    $Res Function(_$CompanyServiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? serviceType = null,
    Object? name = null,
    Object? url = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? apiKey = freezed,
    Object? expirationDate = freezed,
    Object? monthlyCost = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CompanyServiceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as ServiceType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        password: freezed == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String?,
        apiKey: freezed == apiKey
            ? _value.apiKey
            : apiKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        expirationDate: freezed == expirationDate
            ? _value.expirationDate
            : expirationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        monthlyCost: freezed == monthlyCost
            ? _value.monthlyCost
            : monthlyCost // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyServiceImpl implements _CompanyService {
  const _$CompanyServiceImpl({
    required this.id,
    required this.companyId,
    required this.serviceType,
    required this.name,
    this.url,
    this.username,
    this.password,
    this.apiKey,
    this.expirationDate,
    this.monthlyCost,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory _$CompanyServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final ServiceType serviceType;
  @override
  final String name;
  @override
  final String? url;
  @override
  final String? username;
  @override
  final String? password;
  @override
  final String? apiKey;
  @override
  final DateTime? expirationDate;
  @override
  final double? monthlyCost;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CompanyService(id: $id, companyId: $companyId, serviceType: $serviceType, name: $name, url: $url, username: $username, password: $password, apiKey: $apiKey, expirationDate: $expirationDate, monthlyCost: $monthlyCost, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.monthlyCost, monthlyCost) ||
                other.monthlyCost == monthlyCost) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    companyId,
    serviceType,
    name,
    url,
    username,
    password,
    apiKey,
    expirationDate,
    monthlyCost,
    notes,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CompanyService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyServiceImplCopyWith<_$CompanyServiceImpl> get copyWith =>
      __$$CompanyServiceImplCopyWithImpl<_$CompanyServiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyServiceImplToJson(this);
  }
}

abstract class _CompanyService implements CompanyService {
  const factory _CompanyService({
    required final String id,
    required final String companyId,
    required final ServiceType serviceType,
    required final String name,
    final String? url,
    final String? username,
    final String? password,
    final String? apiKey,
    final DateTime? expirationDate,
    final double? monthlyCost,
    final String? notes,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CompanyServiceImpl;

  factory _CompanyService.fromJson(Map<String, dynamic> json) =
      _$CompanyServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  ServiceType get serviceType;
  @override
  String get name;
  @override
  String? get url;
  @override
  String? get username;
  @override
  String? get password;
  @override
  String? get apiKey;
  @override
  DateTime? get expirationDate;
  @override
  double? get monthlyCost;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CompanyService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyServiceImplCopyWith<_$CompanyServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
