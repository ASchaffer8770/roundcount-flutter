import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/db/app_database.dart';
import '../../ammo/providers/ammo_providers.dart';
import '../../firearms/providers/firearm_providers.dart';
import '../../firearms/providers/maintenance_providers.dart';
import '../../sessions/providers/session_providers.dart';
import '../data/dashboard_models.dart';

const _maintenanceRoundThreshold = 500;

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final firearmsAsync = ref.watch(firearmsProvider);
  final ammoAsync = ref.watch(ammoProductsProvider);
  final sessionsAsync = ref.watch(sessionsProvider);
  final runsAsync = ref.watch(allRunsProvider);
  final maintenanceAsync = ref.watch(maintenanceEventsProvider);

  if (firearmsAsync.isLoading ||
      ammoAsync.isLoading ||
      sessionsAsync.isLoading ||
      runsAsync.isLoading ||
      maintenanceAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (firearmsAsync.hasError) {
    return AsyncValue.error(firearmsAsync.error!, firearmsAsync.stackTrace!);
  }
  if (ammoAsync.hasError) {
    return AsyncValue.error(ammoAsync.error!, ammoAsync.stackTrace!);
  }
  if (sessionsAsync.hasError) {
    return AsyncValue.error(sessionsAsync.error!, sessionsAsync.stackTrace!);
  }
  if (runsAsync.hasError) {
    return AsyncValue.error(runsAsync.error!, runsAsync.stackTrace!);
  }
  if (maintenanceAsync.hasError) {
    return AsyncValue.error(
        maintenanceAsync.error!, maintenanceAsync.stackTrace!);
  }

  final firearms = firearmsAsync.requireValue;
  final ammo = ammoAsync.requireValue;
  final sessions = sessionsAsync.requireValue;
  final runs = runsAsync.requireValue;
  final allMaintenance = maintenanceAsync.requireValue;

  // Group all maintenance events by firearmId (already ordered desc by createdAt)
  final maintenanceMap = <String, List<MaintenanceEvent>>{};
  for (final event in allMaintenance) {
    maintenanceMap.putIfAbsent(event.firearmId, () => []).add(event);
  }

  // Ammo on hand — null when no product has roundsOnHand set
  final anyAmmoSet = ammo.any((a) => a.roundsOnHand != null);
  final int? totalAmmoOnHand = anyAmmoSet
      ? ammo.fold(0, (sum, a) => sum! + (a.roundsOnHand ?? 0))
      : null;

  // Recent session (sessionsProvider is ordered desc by startedAt)
  final recentSession = sessions.isNotEmpty ? sessions.first : null;
  final recentRuns = recentSession != null
      ? runs.where((r) => r.sessionId == recentSession.id).toList()
      : <FirearmRun>[];
  final recentSessionRounds =
      recentRuns.fold(0, (sum, r) => sum + r.roundsFired);
  final recentSessionMalfunctions =
      recentRuns.fold(0, (sum, r) => sum + r.malfunctionCount);

  final totalMalfunctions = runs.fold(0, (sum, r) => sum + r.malfunctionCount);

  // Maintenance attention items (500-round MVP threshold)
  final maintenanceItems = <MaintenanceAttentionItem>[];
  for (final firearm in firearms) {
    final events = maintenanceMap[firearm.id] ?? [];
    if (events.isEmpty && firearm.totalRounds > 0) {
      maintenanceItems.add(MaintenanceAttentionItem(
        firearm: firearm,
        statusLine: 'No maintenance logged',
      ));
    } else if (events.isNotEmpty) {
      // events are grouped from a desc-ordered stream — first is most recent
      final latest = events.first;
      final roundsSince = firearm.totalRounds - latest.roundCountAtService;
      if (roundsSince >= _maintenanceRoundThreshold) {
        maintenanceItems.add(MaintenanceAttentionItem(
          firearm: firearm,
          statusLine: '$roundsSince rounds since last service',
        ));
      }
    }
  }

  return AsyncValue.data(DashboardSummary(
    totalFirearms: firearms.length,
    totalAmmoProducts: ammo.length,
    totalAmmoOnHand: totalAmmoOnHand,
    lifetimeRounds: firearms.fold(0, (sum, f) => sum + f.totalRounds),
    totalRuns: runs.length,
    totalSessions: sessions.length,
    recentSession: recentSession,
    recentSessionRounds: recentSessionRounds,
    recentSessionMalfunctions: recentSessionMalfunctions,
    totalMalfunctions: totalMalfunctions,
    maintenanceAttentionItems: maintenanceItems,
  ));
});
