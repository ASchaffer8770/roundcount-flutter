import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../data/ammo_repository.dart';

final ammoRepositoryProvider = Provider<AmmoRepository>((ref) {
  return AmmoRepository(ref.watch(appDatabaseProvider));
});

final ammoProductsProvider = StreamProvider<List<AmmoProduct>>((ref) {
  return ref.watch(ammoRepositoryProvider).watchAll();
});

final ammoProductByIdProvider =
    StreamProvider.family<AmmoProduct?, String>((ref, id) {
  return ref.watch(ammoRepositoryProvider).watchById(id);
});
