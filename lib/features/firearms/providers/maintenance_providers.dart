import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../data/maintenance_repository.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) {
  return MaintenanceRepository(ref.watch(appDatabaseProvider));
});

final maintenanceEventsForFirearmProvider =
    StreamProvider.family<List<MaintenanceEvent>, String>((ref, firearmId) {
  return ref
      .watch(maintenanceRepositoryProvider)
      .watchForFirearm(firearmId);
});
