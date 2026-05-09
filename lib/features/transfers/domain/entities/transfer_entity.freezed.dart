// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransferEntity {
  String get id => throw _privateConstructorUsedError;
  String get fromAccountId => throw _privateConstructorUsedError;
  String get toAccountId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Create a copy of TransferEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferEntityCopyWith<TransferEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferEntityCopyWith<$Res> {
  factory $TransferEntityCopyWith(
    TransferEntity value,
    $Res Function(TransferEntity) then,
  ) = _$TransferEntityCopyWithImpl<$Res, TransferEntity>;
  @useResult
  $Res call({
    String id,
    String fromAccountId,
    String toAccountId,
    double amount,
    String date,
    String description,
  });
}

/// @nodoc
class _$TransferEntityCopyWithImpl<$Res, $Val extends TransferEntity>
    implements $TransferEntityCopyWith<$Res> {
  _$TransferEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromAccountId = null,
    Object? toAccountId = null,
    Object? amount = null,
    Object? date = null,
    Object? description = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromAccountId: null == fromAccountId
                ? _value.fromAccountId
                : fromAccountId // ignore: cast_nullable_to_non_nullable
                      as String,
            toAccountId: null == toAccountId
                ? _value.toAccountId
                : toAccountId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferEntityImplCopyWith<$Res>
    implements $TransferEntityCopyWith<$Res> {
  factory _$$TransferEntityImplCopyWith(
    _$TransferEntityImpl value,
    $Res Function(_$TransferEntityImpl) then,
  ) = __$$TransferEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromAccountId,
    String toAccountId,
    double amount,
    String date,
    String description,
  });
}

/// @nodoc
class __$$TransferEntityImplCopyWithImpl<$Res>
    extends _$TransferEntityCopyWithImpl<$Res, _$TransferEntityImpl>
    implements _$$TransferEntityImplCopyWith<$Res> {
  __$$TransferEntityImplCopyWithImpl(
    _$TransferEntityImpl _value,
    $Res Function(_$TransferEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromAccountId = null,
    Object? toAccountId = null,
    Object? amount = null,
    Object? date = null,
    Object? description = null,
  }) {
    return _then(
      _$TransferEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromAccountId: null == fromAccountId
            ? _value.fromAccountId
            : fromAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
        toAccountId: null == toAccountId
            ? _value.toAccountId
            : toAccountId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TransferEntityImpl implements _TransferEntity {
  const _$TransferEntityImpl({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    this.description = '',
  });

  @override
  final String id;
  @override
  final String fromAccountId;
  @override
  final String toAccountId;
  @override
  final double amount;
  @override
  final String date;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'TransferEntity(id: $id, fromAccountId: $fromAccountId, toAccountId: $toAccountId, amount: $amount, date: $date, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromAccountId, fromAccountId) ||
                other.fromAccountId == fromAccountId) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fromAccountId,
    toAccountId,
    amount,
    date,
    description,
  );

  /// Create a copy of TransferEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferEntityImplCopyWith<_$TransferEntityImpl> get copyWith =>
      __$$TransferEntityImplCopyWithImpl<_$TransferEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _TransferEntity implements TransferEntity {
  const factory _TransferEntity({
    required final String id,
    required final String fromAccountId,
    required final String toAccountId,
    required final double amount,
    required final String date,
    final String description,
  }) = _$TransferEntityImpl;

  @override
  String get id;
  @override
  String get fromAccountId;
  @override
  String get toAccountId;
  @override
  double get amount;
  @override
  String get date;
  @override
  String get description;

  /// Create a copy of TransferEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferEntityImplCopyWith<_$TransferEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
