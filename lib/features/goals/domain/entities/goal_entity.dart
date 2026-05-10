import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/investment_type.dart';

part 'goal_entity.freezed.dart';

@freezed
class GoalEntity with _$GoalEntity {
  const factory GoalEntity({
    required String id,
    required String name,
    @Default('') String description,
    required double targetAmount,
    @Default(0.0) double currentAmount,
    DateTime? targetDate,
    InvestmentType? preferredInvestmentType,
    @Default('star') String icon,
    @Default('#6C63FF') String color,
    @Default(false) bool isCompleted,
  }) = _GoalEntity;
}
