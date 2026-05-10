import '../entities/preferences_entity.dart';

abstract class IPreferencesRepository {
  Stream<PreferencesEntity?> watchPreferences();
  Future<void> updateCurrency(String code, String symbol);
  Future<void> updateThemeMode(String mode);
  Future<void> setAppLock(bool enabled);
}
