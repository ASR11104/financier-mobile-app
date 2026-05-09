// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AccountEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  AccountType get type => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double? get creditLimit => throw _privateConstructorUsedError;
  double? get amountUsed => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of AccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountEntityCopyWith<AccountEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountEntityCopyWith<$Res> {
  factory $AccountEntityCopyWith(
    AccountEntity value,
    $Res Function(AccountEntity) then,
  ) = _$AccountEntityCopyWithImpl<$Res, AccountEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    AccountType type,
    double balance,
    double? creditLimit,
    double? amountUsed,
    String icon,
    String color,
    bool isActive,
    String notes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$AccountEntityCopyWithImpl<$Res, $Val extends AccountEntity>
    implements $AccountEntityCopyWith<$Res> {
  _$AccountEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? creditLimit = freezed,
    Object? amountUsed = freezed,
    Object? icon = null,
    Object? color = null,
    Object? isActive = null,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AccountType,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            creditLimit: freezed == creditLimit
                ? _value.creditLimit
                : creditLimit // ignore: cast_nullable_to_non_nullable
                      as double?,
            amountUsed: freezed == amountUsed
                ? _value.amountUsed
                : amountUsed // ignore: cast_nullable_to_non_nullable
                      as double?,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccountEntityImplCopyWith<$Res>
    implements $AccountEntityCopyWith<$Res> {
  factory _$$AccountEntityImplCopyWith(
    _$AccountEntityImpl value,
    $Res Function(_$AccountEntityImpl) then,
  ) = __$$AccountEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    AccountType type,
    double balance,
    double? creditLimit,
    double? amountUsed,
    String icon,
    String color,
    bool isActive,
    String notes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$AccountEntityImplCopyWithImpl<$Res>
    extends _$AccountEntityCopyWithImpl<$Res, _$AccountEntityImpl>
    implements _$$AccountEntityImplCopyWith<$Res> {
  __$$AccountEntityImplCopyWithImpl(
    _$AccountEntityImpl _value,
    $Res Function(_$AccountEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? creditLimit = freezed,
    Object? amountUsed = freezed,
    Object? icon = null,
    Object? color = null,
    Object? isActive = null,
    Object? notes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AccountEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AccountType,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        creditLimit: freezed == creditLimit
            ? _value.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as double?,
        amountUsed: freezed == amountUsed
            ? _value.amountUsed
            : amountUsed // ignore: cast_nullable_to_non_nullable
                  as double?,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$AccountEntityImpl implements _AccountEntity {
  const _$AccountEntityImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.creditLimit,
    this.amountUsed,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.notes,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final AccountType type;
  @override
  final double balance;
  @override
  final double? creditLimit;
  @override
  final double? amountUsed;
  @override
  final String icon;
  @override
  final String color;
  @override
  final bool isActive;
  @override
  final String notes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AccountEntity(id: $id, name: $name, type: $type, balance: $balance, creditLimit: $creditLimit, amountUsed: $amountUsed, icon: $icon, color: $color, isActive: $isActive, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.amountUsed, amountUsed) ||
                other.amountUsed == amountUsed) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    balance,
    creditLimit,
    amountUsed,
    icon,
    color,
    isActive,
    notes,
    createdAt,
  );

  /// Create a copy of AccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountEntityImplCopyWith<_$AccountEntityImpl> get copyWith =>
      __$$AccountEntityImplCopyWithImpl<_$AccountEntityImpl>(this, _$identity);
}

abstract class _AccountEntity implements AccountEntity {
  const factory _AccountEntity({
    required final String id,
    required final String name,
    required final AccountType type,
    required final double balance,
    final double? creditLimit,
    final double? amountUsed,
    required final String icon,
    required final String color,
    required final bool isActive,
    required final String notes,
    required final DateTime createdAt,
  }) = _$AccountEntityImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  AccountType get type;
  @override
  double get balance;
  @override
  double? get creditLimit;
  @override
  double? get amountUsed;
  @override
  String get icon;
  @override
  String get color;
  @override
  bool get isActive;
  @override
  String get notes;
  @override
  DateTime get createdAt;

  /// Create a copy of AccountEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountEntityImplCopyWith<_$AccountEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
