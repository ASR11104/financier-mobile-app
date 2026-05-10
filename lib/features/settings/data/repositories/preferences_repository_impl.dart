import 'package:injectable/injectable.dart';

import '../../../../database/daos/preferences_dao.dart';
import '../../domain/entities/preferences_entity.dart';
import '../../domain/repositories/i_preferences_repository.dart';

@LazySingleton(as: IPreferencesRepository)
class PreferencesRepositoryImpl implements IPreferencesRepository {
  final PreferencesDao _dao;

  PreferencesRepositoryImpl(this._dao);

  @override
  Stream<PreferencesEntity?> watchPreferences() {
    return _dao.watchPreferences().map((row) {
      if (row == null) return null;
      return PreferencesEntity(
        currencyCode: row.currencyCode,
        currencySymbol: row.currencySymbol,
        themeMode: row.themeMode,
        isLockEnabled: row.isLockEnabled == 1,
      );
    });
  }

  @override
  Future<void> updateCurrency(String code, String symbol) {
    return _dao.updateCurrency(code, symbol);
  }

  @override
  Future<void> updateThemeMode(String mode) {
    return _dao.updateThemeMode(mode);
  }

  @override
  Future<void> setAppLock(bool enabled) {
    return _dao.updateAppLock(enabled);
  }
}
