import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/accounts_table.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/goals_table.dart';
import 'tables/ledger_entries_table.dart';
import 'tables/tags_table.dart';
import 'tables/transaction_tags_table.dart';
import 'tables/transactions_table.dart';
import 'tables/transfers_table.dart';
import 'tables/user_preferences_table.dart';
import 'daos/accounts_dao.dart';
import 'daos/budgets_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/goals_dao.dart';
import 'daos/ledger_dao.dart';
import 'daos/preferences_dao.dart';
import 'daos/tags_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/transfers_dao.dart';

part 'app_database.g.dart';

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
    Budgets,
    Goals,
  ],
  daos: [
    AccountsDao,
    CategoriesDao,
    TagsDao,
    TransactionsDao,
    TransfersDao,
    LedgerDao,
    PreferencesDao,
    BudgetsDao,
    GoalsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'finsight_db');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(
                userPreferences, userPreferences.isLockEnabled);
            await m.addColumn(transactions, transactions.goalId);
            await m.createTable(budgets);
            await m.createTable(goals);
          }
        },
      );
}
