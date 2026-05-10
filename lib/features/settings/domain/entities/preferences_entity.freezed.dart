// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PreferencesEntity {
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  String get themeMode => throw _privateConstructorUsedError;
  bool get isLockEnabled => throw _privateConstructorUsedError;

  /// Create a copy of PreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferencesEntityCopyWith<PreferencesEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferencesEntityCopyWith<$Res> {
  factory $PreferencesEntityCopyWith(
    PreferencesEntity value,
    $Res Function(PreferencesEntity) then,
  ) = _$PreferencesEntityCopyWithImpl<$Res, PreferencesEntity>;
  @useResult
  $Res call({
    String currencyCode,
    String currencySymbol,
    String themeMode,
    bool isLockEnabled,
  });
}

/// @nodoc
class _$PreferencesEntityCopyWithImpl<$Res, $Val extends PreferencesEntity>
    implements $PreferencesEntityCopyWith<$Res> {
  _$PreferencesEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? themeMode = null,
    Object? isLockEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            currencyCode: null == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                      as String,
            currencySymbol: null == currencySymbol
                ? _value.currencySymbol
                : currencySymbol // ignore: cast_nullable_to_non_nullable
                      as String,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as String,
            isLockEnabled: null == isLockEnabled
                ? _value.isLockEnabled
                : isLockEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PreferencesEntityImplCopyWith<$Res>
    implements $PreferencesEntityCopyWith<$Res> {
  factory _$$PreferencesEntityImplCopyWith(
    _$PreferencesEntityImpl value,
    $Res Function(_$PreferencesEntityImpl) then,
  ) = __$$PreferencesEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String currencyCode,
    String currencySymbol,
    String themeMode,
    bool isLockEnabled,
  });
}

/// @nodoc
class __$$PreferencesEntityImplCopyWithImpl<$Res>
    extends _$PreferencesEntityCopyWithImpl<$Res, _$PreferencesEntityImpl>
    implements _$$PreferencesEntityImplCopyWith<$Res> {
  __$$PreferencesEntityImplCopyWithImpl(
    _$PreferencesEntityImpl _value,
    $Res Function(_$PreferencesEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = null,
    Object? currencySymbol = null,
    Object? themeMode = null,
    Object? isLockEnabled = null,
  }) {
    return _then(
      _$PreferencesEntityImpl(
        currencyCode: null == currencyCode
            ? _value.currencyCode
            : currencyCode // ignore: cast_nullable_to_non_nullable
                  as String,
        currencySymbol: null == currencySymbol
            ? _value.currencySymbol
            : currencySymbol // ignore: cast_nullable_to_non_nullable
                  as String,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as String,
        isLockEnabled: null == isLockEnabled
            ? _value.isLockEnabled
            : isLockEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PreferencesEntityImpl implements _PreferencesEntity {
  const _$PreferencesEntityImpl({
    required this.currencyCode,
    required this.currencySymbol,
    this.themeMode = 'system',
    this.isLockEnabled = false,
  });

  @override
  final String currencyCode;
  @override
  final String currencySymbol;
  @override
  @JsonKey()
  final String themeMode;
  @override
  @JsonKey()
  final bool isLockEnabled;

  @override
  String toString() {
    return 'PreferencesEntity(currencyCode: $currencyCode, currencySymbol: $currencySymbol, themeMode: $themeMode, isLockEnabled: $isLockEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferencesEntityImpl &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.isLockEnabled, isLockEnabled) ||
                other.isLockEnabled == isLockEnabled));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currencyCode,
    currencySymbol,
    themeMode,
    isLockEnabled,
  );

  /// Create a copy of PreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferencesEntityImplCopyWith<_$PreferencesEntityImpl> get copyWith =>
      __$$PreferencesEntityImplCopyWithImpl<_$PreferencesEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _PreferencesEntity implements PreferencesEntity {
  const factory _PreferencesEntity({
    required final String currencyCode,
    required final String currencySymbol,
    final String themeMode,
    final bool isLockEnabled,
  }) = _$PreferencesEntityImpl;

  @override
  String get currencyCode;
  @override
  String get currencySymbol;
  @override
  String get themeMode;
  @override
  bool get isLockEnabled;

  /// Create a copy of PreferencesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferencesEntityImplCopyWith<_$PreferencesEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
