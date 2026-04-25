import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../data/firearm_repository.dart';

final firearmRepositoryProvider = Provider<FirearmRepository>((ref) {
  return FirearmRepository(ref.watch(appDatabaseProvider));
});

final firearmsProvider = StreamProvider<List<Firearm>>((ref) {
  return ref.watch(firearmRepositoryProvider).watchAll();
});

final firearmByIdProvider =
    StreamProvider.family<Firearm?, String>((ref, id) {
  return ref.watch(firearmRepositoryProvider).watchById(id);
});
