import 'package:injectable/injectable.dart';

import '../../database/app_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/categories_dao.dart';
import '../../database/daos/ledger_dao.dart';
import '../../database/daos/preferences_dao.dart';
import '../../database/daos/tags_dao.dart';
import '../../database/daos/transactions_dao.dart';
import '../../database/daos/transfers_dao.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  AccountsDao accountsDao(AppDatabase db) => db.accountsDao;

  @lazySingleton
  CategoriesDao categoriesDao(AppDatabase db) => db.categoriesDao;

  @lazySingleton
  TagsDao tagsDao(AppDatabase db) => db.tagsDao;

  @lazySingleton
  TransactionsDao transactionsDao(AppDatabase db) => db.transactionsDao;

  @lazySingleton
  TransfersDao transfersDao(AppDatabase db) => db.transfersDao;

  @lazySingleton
  LedgerDao ledgerDao(AppDatabase db) => db.ledgerDao;

  @lazySingleton
  PreferencesDao preferencesDao(AppDatabase db) => db.preferencesDao;
}
