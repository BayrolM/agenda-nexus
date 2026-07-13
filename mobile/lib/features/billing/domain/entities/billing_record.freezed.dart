// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillingRecord _$BillingRecordFromJson(Map<String, dynamic> json) {
  return _BillingRecord.fromJson(json);
}

/// @nodoc
mixin _$BillingRecord {
  String get id => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  DateTime get reminderDate => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  BillingStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BillingRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillingRecordCopyWith<BillingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillingRecordCopyWith<$Res> {
  factory $BillingRecordCopyWith(
    BillingRecord value,
    $Res Function(BillingRecord) then,
  ) = _$BillingRecordCopyWithImpl<$Res, BillingRecord>;
  @useResult
  $Res call({
    String id,
    String companyId,
    DateTime reminderDate,
    double? amount,
    BillingStatus status,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$BillingRecordCopyWithImpl<$Res, $Val extends BillingRecord>
    implements $BillingRecordCopyWith<$Res> {
  _$BillingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? reminderDate = null,
    Object? amount = freezed,
    Object? status = null,
    Object? createdAt = freezed,
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
            reminderDate: null == reminderDate
                ? _value.reminderDate
                : reminderDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BillingStatus,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillingRecordImplCopyWith<$Res>
    implements $BillingRecordCopyWith<$Res> {
  factory _$$BillingRecordImplCopyWith(
    _$BillingRecordImpl value,
    $Res Function(_$BillingRecordImpl) then,
  ) = __$$BillingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String companyId,
    DateTime reminderDate,
    double? amount,
    BillingStatus status,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$BillingRecordImplCopyWithImpl<$Res>
    extends _$BillingRecordCopyWithImpl<$Res, _$BillingRecordImpl>
    implements _$$BillingRecordImplCopyWith<$Res> {
  __$$BillingRecordImplCopyWithImpl(
    _$BillingRecordImpl _value,
    $Res Function(_$BillingRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? reminderDate = null,
    Object? amount = freezed,
    Object? status = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BillingRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        companyId: null == companyId
            ? _value.companyId
            : companyId // ignore: cast_nullable_to_non_nullable
                  as String,
        reminderDate: null == reminderDate
            ? _value.reminderDate
            : reminderDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BillingStatus,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillingRecordImpl implements _BillingRecord {
  const _$BillingRecordImpl({
    required this.id,
    required this.companyId,
    required this.reminderDate,
    this.amount,
    this.status = BillingStatus.pending,
    this.createdAt,
  });

  factory _$BillingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillingRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String companyId;
  @override
  final DateTime reminderDate;
  @override
  final double? amount;
  @override
  @JsonKey()
  final BillingStatus status;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BillingRecord(id: $id, companyId: $companyId, reminderDate: $reminderDate, amount: $amount, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillingRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.reminderDate, reminderDate) ||
                other.reminderDate == reminderDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    companyId,
    reminderDate,
    amount,
    status,
    createdAt,
  );

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillingRecordImplCopyWith<_$BillingRecordImpl> get copyWith =>
      __$$BillingRecordImplCopyWithImpl<_$BillingRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillingRecordImplToJson(this);
  }
}

abstract class _BillingRecord implements BillingRecord {
  const factory _BillingRecord({
    required final String id,
    required final String companyId,
    required final DateTime reminderDate,
    final double? amount,
    final BillingStatus status,
    final DateTime? createdAt,
  }) = _$BillingRecordImpl;

  factory _BillingRecord.fromJson(Map<String, dynamic> json) =
      _$BillingRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get companyId;
  @override
  DateTime get reminderDate;
  @override
  double? get amount;
  @override
  BillingStatus get status;
  @override
  DateTime? get createdAt;

  /// Create a copy of BillingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillingRecordImplCopyWith<_$BillingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
