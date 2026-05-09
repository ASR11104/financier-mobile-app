import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/transaction_entity.dart';
import '../domain/repositories/i_transaction_repository.dart';

part 'transactions_providers.g.dart';

@riverpod
ITransactionRepository transactionRepository(Ref ref) =>
    getIt<ITransactionRepository>();

@riverpod
Stream<List<TransactionEntity>> transactions(Ref ref) =>
    ref.watch(transactionRepositoryProvider).watchAll();

@riverpod
Stream<List<TransactionEntity>> transactionsByType(Ref ref, String type) =>
    ref.watch(transactionRepositoryProvider).watchByType(type);

@riverpod
Stream<List<TransactionEntity>> recentTransactions(Ref ref,
    {int limit = 10}) =>
    ref
        .watch(transactionRepositoryProvider)
        .watchAll()
        .map((list) => list.take(limit).toList());
