import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user_preferences_table.dart';

part 'preferences_dao.g.dart';

/// Data Access Object for the [UserPreferences] table.
///
/// This is a singleton row (id = 1) storing app-wide settings.
@DriftAccessor(tables: [UserPreferences])
class PreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$PreferencesDaoMixin {
  PreferencesDao(super.db);

  /// Watch the user preferences (reactive).
  Stream<UserPreference?> watchPreferences() {
    return (select(userPreferences)..where((p) => p.id.equals(1)))
        .watchSingleOrNull();
  }

  /// Get the current user preferences.
  Future<UserPreference?> getPreferences() {
    return (select(userPreferences)..where((p) => p.id.equals(1)))
        .getSingleOrNull();
  }

  /// Update the currency setting.
  Future<void> updateCurrency(String code, String symbol) {
    return (update(userPreferences)..where((p) => p.id.equals(1))).write(
      UserPreferencesCompanion(
        currencyCode: Value(code),
        currencySymbol: Value(symbol),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update the theme mode setting.
  Future<void> updateThemeMode(String mode) {
    return (update(userPreferences)..where((p) => p.id.equals(1))).write(
      UserPreferencesCompanion(
        themeMode: Value(mode),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
