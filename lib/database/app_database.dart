import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/ledger_entries_table.dart';
import 'tables/tags_table.dart';
import 'tables/transaction_tags_table.dart';
import 'tables/transactions_table.dart';
import 'tables/transfers_table.dart';
import 'tables/user_preferences_table.dart';
import 'daos/accounts_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/ledger_dao.dart';
import 'daos/preferences_dao.dart';
import 'daos/tags_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/transfers_dao.dart';

part 'app_database.g.dart';

/// The main database for the Finsight app.
///
/// Uses Drift ORM on top of SQLite for type-safe, reactive queries.
/// The database is local-only — all data lives on the device.
@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Tags,
    Transactions,
    TransactionTags,
    Transfers,
    LedgerEntries,
    UserPreferences,
  ],
  daos: [
    AccountsDao,
    CategoriesDao,
    TagsDao,
    TransactionsDao,
    TransfersDao,
    LedgerDao,
    PreferencesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'finsight_db');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations go here
        },
      );
}
