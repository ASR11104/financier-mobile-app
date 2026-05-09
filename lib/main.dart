import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'database/app_database.dart';
import 'database/seed_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and seed default data
  final db = AppDatabase();
  await SeedData.seed(db);

  runApp(
    const ProviderScope(
      child: FinsightApp(),
    ),
  );
}
