// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionEntity {
  String get id => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  InvestmentType? get investmentType => throw _privateConstructorUsedError;
  List<String> get tagIds => throw _privateConstructorUsedError;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
    TransactionEntity value,
    $Res Function(TransactionEntity) then,
  ) = _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call({
    String id,
    TransactionType type,
    double amount,
    String accountId,
    String categoryId,
    String date,
    String description,
    InvestmentType? investmentType,
    List<String> tagIds,
  });
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? accountId = null,
    Object? categoryId = null,
    Object? date = null,
    Object? description = null,
    Object? investmentType = freezed,
    Object? tagIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            investmentType: freezed == investmentType
                ? _value.investmentType
                : investmentType // ignore: cast_nullable_to_non_nullable
                      as InvestmentType?,
            tagIds: null == tagIds
                ? _value.tagIds
                : tagIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionEntityImplCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$TransactionEntityImplCopyWith(
    _$TransactionEntityImpl value,
    $Res Function(_$TransactionEntityImpl) then,
  ) = __$$TransactionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    TransactionType type,
    double amount,
    String accountId,
    String categoryId,
    String date,
    String description,
    InvestmentType? investmentType,
    List<String> tagIds,
  });
}

/// @nodoc
class __$$TransactionEntityImplCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$TransactionEntityImpl>
    implements _$$TransactionEntityImplCopyWith<$Res> {
  __$$TransactionEntityImplCopyWithImpl(
    _$TransactionEntityImpl _value,
    $Res Function(_$TransactionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? accountId = null,
    Object? categoryId = null,
    Object? date = null,
    Object? description = null,
    Object? investmentType = freezed,
    Object? tagIds = null,
  }) {
    return _then(
      _$TransactionEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        investmentType: freezed == investmentType
            ? _value.investmentType
            : investmentType // ignore: cast_nullable_to_non_nullable
                  as InvestmentType?,
        tagIds: null == tagIds
            ? _value._tagIds
            : tagIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$TransactionEntityImpl implements _TransactionEntity {
  const _$TransactionEntityImpl({
    required this.id,
    required this.type,
    required this.amount,
    required this.accountId,
    required this.categoryId,
    required this.date,
    this.description = '',
    this.investmentType,
    final List<String> tagIds = const [],
  }) : _tagIds = tagIds;

  @override
  final String id;
  @override
  final TransactionType type;
  @override
  final double amount;
  @override
  final String accountId;
  @override
  final String categoryId;
  @override
  final String date;
  @override
  @JsonKey()
  final String description;
  @override
  final InvestmentType? investmentType;
  final List<String> _tagIds;
  @override
  @JsonKey()
  List<String> get tagIds {
    if (_tagIds is EqualUnmodifiableListView) return _tagIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tagIds);
  }

  @override
  String toString() {
    return 'TransactionEntity(id: $id, type: $type, amount: $amount, accountId: $accountId, categoryId: $categoryId, date: $date, description: $description, investmentType: $investmentType, tagIds: $tagIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.investmentType, investmentType) ||
                other.investmentType == investmentType) &&
            const DeepCollectionEquality().equals(other._tagIds, _tagIds));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    amount,
    accountId,
    categoryId,
    date,
    description,
    investmentType,
    const DeepCollectionEquality().hash(_tagIds),
  );

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      __$$TransactionEntityImplCopyWithImpl<_$TransactionEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionEntity implements TransactionEntity {
  const factory _TransactionEntity({
    required final String id,
    required final TransactionType type,
    required final double amount,
    required final String accountId,
    required final String categoryId,
    required final String date,
    final String description,
    final InvestmentType? investmentType,
    final List<String> tagIds,
  }) = _$TransactionEntityImpl;

  @override
  String get id;
  @override
  TransactionType get type;
  @override
  double get amount;
  @override
  String get accountId;
  @override
  String get categoryId;
  @override
  String get date;
  @override
  String get description;
  @override
  InvestmentType? get investmentType;
  @override
  List<String> get tagIds;

  /// Create a copy of TransactionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionEntityImplCopyWith<_$TransactionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
