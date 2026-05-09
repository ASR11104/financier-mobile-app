import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/transfer_entity.dart';
import '../domain/repositories/i_transfer_repository.dart';

part 'transfers_providers.g.dart';

@riverpod
ITransferRepository transferRepository(Ref ref) =>
    getIt<ITransferRepository>();

@riverpod
Stream<List<TransferEntity>> transfers(Ref ref) =>
    ref.watch(transferRepositoryProvider).watchAll();
