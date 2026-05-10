// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finsight/core/di/database_module.dart' as _i1059;
import 'package:finsight/core/services/biometric_auth_service.dart' as _i237;
import 'package:finsight/core/services/transaction_ledger_service.dart'
    as _i465;
import 'package:finsight/database/app_database.dart' as _i63;
import 'package:finsight/database/daos/accounts_dao.dart' as _i431;
import 'package:finsight/database/daos/budgets_dao.dart' as _i461;
import 'package:finsight/database/daos/categories_dao.dart' as _i879;
import 'package:finsight/database/daos/goals_dao.dart' as _i789;
import 'package:finsight/database/daos/ledger_dao.dart' as _i1064;
import 'package:finsight/database/daos/preferences_dao.dart' as _i643;
import 'package:finsight/database/daos/tags_dao.dart' as _i138;
import 'package:finsight/database/daos/transactions_dao.dart' as _i1034;
import 'package:finsight/database/daos/transfers_dao.dart' as _i769;
import 'package:finsight/features/accounts/data/repositories/account_repository_impl.dart'
    as _i278;
import 'package:finsight/features/accounts/domain/repositories/i_account_repository.dart'
    as _i681;
import 'package:finsight/features/budgets/data/repositories/budget_repository_impl.dart'
    as _i1060;
import 'package:finsight/features/budgets/domain/repositories/i_budget_repository.dart'
    as _i219;
import 'package:finsight/features/categories/data/repositories/category_repository_impl.dart'
    as _i798;
import 'package:finsight/features/categories/domain/repositories/i_category_repository.dart'
    as _i281;
import 'package:finsight/features/goals/data/repositories/goal_repository_impl.dart'
    as _i737;
import 'package:finsight/features/goals/domain/repositories/i_goal_repository.dart'
    as _i562;
import 'package:finsight/features/settings/data/repositories/preferences_repository_impl.dart'
    as _i708;
import 'package:finsight/features/settings/domain/repositories/i_preferences_repository.dart'
    as _i568;
import 'package:finsight/features/tags/data/repositories/tag_repository_impl.dart'
    as _i1001;
import 'package:finsight/features/tags/domain/repositories/i_tag_repository.dart'
    as _i53;
import 'package:finsight/features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i219;
import 'package:finsight/features/transactions/domain/repositories/i_transaction_repository.dart'
    as _i333;
import 'package:finsight/features/transfers/data/repositories/transfer_repository_impl.dart'
    as _i387;
import 'package:finsight/features/transfers/domain/repositories/i_transfer_repository.dart'
    as _i859;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    gh.singleton<_i63.AppDatabase>(() => databaseModule.appDatabase);
    gh.lazySingleton<_i237.BiometricAuthService>(
      () => _i237.BiometricAuthService(),
    );
    gh.lazySingleton<_i431.AccountsDao>(
      () => databaseModule.accountsDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i879.CategoriesDao>(
      () => databaseModule.categoriesDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i138.TagsDao>(
      () => databaseModule.tagsDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i1034.TransactionsDao>(
      () => databaseModule.transactionsDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i769.TransfersDao>(
      () => databaseModule.transfersDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i1064.LedgerDao>(
      () => databaseModule.ledgerDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i643.PreferencesDao>(
      () => databaseModule.preferencesDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i461.BudgetsDao>(
      () => databaseModule.budgetsDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i789.GoalsDao>(
      () => databaseModule.goalsDao(gh<_i63.AppDatabase>()),
    );
    gh.lazySingleton<_i568.IPreferencesRepository>(
      () => _i708.PreferencesRepositoryImpl(gh<_i643.PreferencesDao>()),
    );
    gh.lazySingleton<_i219.IBudgetRepository>(
      () => _i1060.BudgetRepositoryImpl(gh<_i461.BudgetsDao>()),
    );
    gh.lazySingleton<_i281.ICategoryRepository>(
      () => _i798.CategoryRepositoryImpl(gh<_i879.CategoriesDao>()),
    );
    gh.lazySingleton<_i53.ITagRepository>(
      () => _i1001.TagRepositoryImpl(gh<_i138.TagsDao>()),
    );
    gh.lazySingleton<_i859.ITransferRepository>(
      () => _i387.TransferRepositoryImpl(
        gh<_i63.AppDatabase>(),
        gh<_i769.TransfersDao>(),
        gh<_i431.AccountsDao>(),
        gh<_i1064.LedgerDao>(),
      ),
    );
    gh.lazySingleton<_i465.TransactionLedgerService>(
      () => _i465.TransactionLedgerService(
        gh<_i1034.TransactionsDao>(),
        gh<_i1064.LedgerDao>(),
        gh<_i431.AccountsDao>(),
        gh<_i789.GoalsDao>(),
      ),
    );
    gh.lazySingleton<_i681.IAccountRepository>(
      () => _i278.AccountRepositoryImpl(gh<_i431.AccountsDao>()),
    );
    gh.lazySingleton<_i562.IGoalRepository>(
      () => _i737.GoalRepositoryImpl(
        gh<_i63.AppDatabase>(),
        gh<_i789.GoalsDao>(),
        gh<_i1034.TransactionsDao>(),
        gh<_i465.TransactionLedgerService>(),
      ),
    );
    gh.lazySingleton<_i333.ITransactionRepository>(
      () => _i219.TransactionRepositoryImpl(
        gh<_i63.AppDatabase>(),
        gh<_i1034.TransactionsDao>(),
        gh<_i465.TransactionLedgerService>(),
      ),
    );
    return this;
  }
}

class _$DatabaseModule extends _i1059.DatabaseModule {}
