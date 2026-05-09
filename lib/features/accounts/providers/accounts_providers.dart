import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/account_entity.dart';
import '../domain/repositories/i_account_repository.dart';

part 'accounts_providers.g.dart';

@riverpod
IAccountRepository accountRepository(Ref ref) => getIt<IAccountRepository>();

@riverpod
Stream<List<AccountEntity>> accounts(Ref ref) =>
    ref.watch(accountRepositoryProvider).watchAllActive();

@riverpod
Stream<AccountEntity?> accountById(Ref ref, String id) =>
    ref.watch(accountRepositoryProvider).watchById(id);
