import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_entity.freezed.dart';

@freezed
class PreferencesEntity with _$PreferencesEntity {
  const factory PreferencesEntity({
    required String currencyCode,
    required String currencySymbol,
    @Default('system') String themeMode,
  }) = _PreferencesEntity;
}
