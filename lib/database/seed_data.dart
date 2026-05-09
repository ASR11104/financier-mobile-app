import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

const _uuid = Uuid();

/// Default categories pre-seeded into the database on first launch.
class SeedData {
  SeedData._();

  /// Seeds the database with default categories and user preferences.
  static Future<void> seed(AppDatabase db) async {
    await _seedCategories(db);
    await _seedPreferences(db);
  }

  static Future<void> _seedCategories(AppDatabase db) async {
    // Check if categories already exist
    final existing = await db.select(db.categories).get();
    if (existing.isNotEmpty) return;

    // Expense categories
    final expenseCategories = [
      ('Food & Dining', 'restaurant', '#FF5722', 1),
      ('Transport', 'car', '#2196F3', 2),
      ('Shopping', 'shopping_bag', '#E91E63', 3),
      ('Entertainment', 'movie', '#9C27B0', 4),
      ('Bills & Utilities', 'receipt', '#607D8B', 5),
      ('Health', 'heart', '#4CAF50', 6),
      ('Education', 'book', '#3F51B5', 7),
      ('Groceries', 'cart', '#8BC34A', 8),
      ('Personal Care', 'spa', '#FF9800', 9),
      ('Rent', 'home', '#795548', 10),
      ('Other', 'more_horiz', '#9E9E9E', 11),
    ];

    for (final (name, icon, color, order) in expenseCategories) {
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: _uuid.v4(),
              name: name,
              type: 'expense',
              icon: Value(icon),
              color: Value(color),
              sortOrder: Value(order),
              isDefault: const Value(1),
            ),
          );
    }

    // Income categories
    final incomeCategories = [
      ('Salary', 'payments', '#4CAF50', 1),
      ('Freelance', 'work', '#2196F3', 2),
      ('Investment Returns', 'trending_up', '#FF9800', 3),
      ('Debt Repayment Received', 'account_balance', '#00BCD4', 4),
      ('Gifts', 'card_giftcard', '#E91E63', 5),
      ('Other', 'more_horiz', '#9E9E9E', 6),
    ];

    for (final (name, icon, color, order) in incomeCategories) {
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: _uuid.v4(),
              name: name,
              type: 'income',
              icon: Value(icon),
              color: Value(color),
              sortOrder: Value(order),
              isDefault: const Value(1),
            ),
          );
    }

    // Investment categories
    final investmentCategories = [
      ('Mutual Funds', 'pie_chart', '#673AB7', 1),
      ('Stocks', 'show_chart', '#F44336', 2),
      ('ETFs', 'assessment', '#009688', 3),
      ('Bonds', 'security', '#FF5722', 4),
      ('Fixed Deposits', 'lock', '#795548', 5),
      ('Other', 'more_horiz', '#9E9E9E', 6),
    ];

    for (final (name, icon, color, order) in investmentCategories) {
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              id: _uuid.v4(),
              name: name,
              type: 'investment',
              icon: Value(icon),
              color: Value(color),
              sortOrder: Value(order),
              isDefault: const Value(1),
            ),
          );
    }
  }

  static Future<void> _seedPreferences(AppDatabase db) async {
    // Check if preferences already exist
    final existing = await db.select(db.userPreferences).get();
    if (existing.isNotEmpty) return;

    await db.into(db.userPreferences).insert(
          UserPreferencesCompanion.insert(),
        );
  }
}
