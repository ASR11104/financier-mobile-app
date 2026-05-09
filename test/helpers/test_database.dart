import 'package:drift/native.dart';
import 'package:finsight/database/app_database.dart';

AppDatabase openTestDatabase() => AppDatabase.forTesting(NativeDatabase.memory());
