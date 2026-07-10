import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database.dart';
import 'daos.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final daoProvider = Provider<AppDao>((ref) {
  return AppDao(ref.watch(databaseProvider));
});
