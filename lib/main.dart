import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'database/app_database.dart';
import 'database/seed_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await SeedData.seed(getIt<AppDatabase>());
  runApp(
    const ProviderScope(
      child: FinsightApp(),
    ),
  );
}
