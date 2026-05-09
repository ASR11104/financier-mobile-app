import 'package:drift/drift.dart';

import 'tags_table.dart';
import 'transactions_table.dart';

/// Many-to-many join table between transactions and tags.
///
/// A transaction can have multiple tags, and a tag can be
/// applied to multiple transactions.
class TransactionTags extends Table {
  /// Foreign key to the transaction.
  TextColumn get transactionId =>
      text().references(Transactions, #id)();

  /// Foreign key to the tag.
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {transactionId, tagId};
}
