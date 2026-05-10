import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/investment_type.dart';
import '../../../../core/enums/transaction_type.dart';

part 'transaction_entity.freezed.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required TransactionType type,
    required double amount,
    required String accountId,
    required String categoryId,
    required String date,
    @Default('') String description,
    InvestmentType? investmentType,
    @Default([]) List<String> tagIds,
    String? goalId,
  }) = _TransactionEntity;
}
