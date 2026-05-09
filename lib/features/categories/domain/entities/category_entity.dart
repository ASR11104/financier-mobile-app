import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/transaction_type.dart';

part 'category_entity.freezed.dart';

@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required TransactionType type,
    required String icon,
    required String color,
    required int sortOrder,
    required bool isDefault,
  }) = _CategoryEntity;
}
