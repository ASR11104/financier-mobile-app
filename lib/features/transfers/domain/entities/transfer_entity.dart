import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_entity.freezed.dart';

@freezed
class TransferEntity with _$TransferEntity {
  const factory TransferEntity({
    required String id,
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    required String date,
    @Default('') String description,
  }) = _TransferEntity;
}
