import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../data/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.watch(appDatabaseProvider));
});

final sessionsProvider = StreamProvider<List<RangeSession>>((ref) {
  return ref.watch(sessionRepositoryProvider).watchAllSessions();
});

final sessionByIdProvider =
    StreamProvider.family<RangeSession?, String>((ref, id) {
  return ref.watch(sessionRepositoryProvider).watchSessionById(id);
});

final runsForSessionProvider =
    StreamProvider.family<List<FirearmRun>, String>((ref, sessionId) {
  return ref.watch(sessionRepositoryProvider).watchRunsForSession(sessionId);
});

final runsForFirearmProvider =
    StreamProvider.family<List<FirearmRun>, String>((ref, firearmId) {
  return ref.watch(sessionRepositoryProvider).watchRunsForFirearm(firearmId);
});
