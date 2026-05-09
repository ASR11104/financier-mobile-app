import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/account_type.dart';

part 'account_entity.freezed.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required String id,
    required String name,
    required AccountType type,
    required double balance,
    double? creditLimit,
    double? amountUsed,
    required String icon,
    required String color,
    required bool isActive,
    required String notes,
    required DateTime createdAt,
  }) = _AccountEntity;
}
