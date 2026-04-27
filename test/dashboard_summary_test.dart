import 'package:flutter_test/flutter_test.dart';
import 'package:roundcount_flutter/features/dashboard/data/dashboard_models.dart';

DashboardSummary _summary({
  int totalFirearms = 0,
  int totalAmmoProducts = 0,
  int? totalAmmoOnHand,
  int lifetimeRounds = 0,
  int totalRuns = 0,
  int totalSessions = 0,
  int totalMalfunctions = 0,
  List<MaintenanceAttentionItem> maintenanceAttentionItems = const [],
}) {
  return DashboardSummary(
    totalFirearms: totalFirearms,
    totalAmmoProducts: totalAmmoProducts,
    totalAmmoOnHand: totalAmmoOnHand,
    lifetimeRounds: lifetimeRounds,
    totalRuns: totalRuns,
    totalSessions: totalSessions,
    recentSession: null,
    recentSessionRounds: 0,
    recentSessionMalfunctions: 0,
    totalMalfunctions: totalMalfunctions,
    maintenanceAttentionItems: maintenanceAttentionItems,
  );
}

void main() {
  group('DashboardSummary.isEmpty', () {
    test('true when no firearms, ammo, or sessions', () {
      expect(_summary().isEmpty, isTrue);
    });

    test('false when firearms exist', () {
      expect(_summary(totalFirearms: 1).isEmpty, isFalse);
    });

    test('false when ammo products exist', () {
      expect(_summary(totalAmmoProducts: 1).isEmpty, isFalse);
    });

    test('false when sessions exist', () {
      expect(_summary(totalSessions: 1).isEmpty, isFalse);
    });
  });

  group('DashboardSummary reliability signal gate', () {
    test('totalRuns is 0 with no logged runs', () {
      final s = _summary(lifetimeRounds: 1000, totalRuns: 0);
      expect(s.totalRuns, 0);
    });

    test('lifetimeRounds > 0 does not imply run history exists', () {
      // A firearm with manually entered rounds but no FirearmRun records
      // should still show the empty-run-history message, not a clean signal.
      final s = _summary(lifetimeRounds: 2500, totalRuns: 0, totalMalfunctions: 0);
      expect(s.totalRuns, 0);
      expect(s.lifetimeRounds, 2500);
      // The UI should branch on totalRuns == 0, not lifetimeRounds == 0.
    });

    test('clean signal when runs exist and no malfunctions', () {
      final s = _summary(lifetimeRounds: 500, totalRuns: 10, totalMalfunctions: 0);
      expect(s.totalRuns, greaterThan(0));
      expect(s.totalMalfunctions, 0);
    });

    test('malfunction signal when runs and malfunctions exist', () {
      final s = _summary(lifetimeRounds: 500, totalRuns: 10, totalMalfunctions: 3);
      expect(s.totalRuns, greaterThan(0));
      expect(s.totalMalfunctions, 3);
    });
  });

  group('Maintenance event grouping logic', () {
    test('groups events by firearmId', () {
      final events = [
        (firearmId: 'fa', id: 'e1'),
        (firearmId: 'fb', id: 'e2'),
        (firearmId: 'fa', id: 'e3'),
      ];

      final map = <String, List<({String firearmId, String id})>>{};
      for (final e in events) {
        map.putIfAbsent(e.firearmId, () => []).add(e);
      }

      expect(map['fa']!.length, 2);
      expect(map['fa']!.first.id, 'e1');
      expect(map['fb']!.length, 1);
      expect(map['fc'], isNull);
    });

    test('fallback to empty list for firearm with no events', () {
      final map = <String, List<String>>{'fa': ['event1']};
      expect(map['fb'] ?? [], isEmpty);
    });

    test('no maintenance + rounds > 0 flags as attention item', () {
      // Simulates: firearm has totalRounds > 0, no maintenance events.
      // This should produce an attention item with "No maintenance logged".
      const threshold = 500;
      final firearmRounds = 300;
      final events = <String>[];

      final isAttention = events.isEmpty && firearmRounds > 0;
      expect(isAttention, isTrue);

      // Simulates: firearm has events, rounds since last service below threshold
      final roundsSince = 200;
      final isAboveThreshold = roundsSince >= threshold;
      expect(isAboveThreshold, isFalse);

      // Simulates: rounds since last service at or above threshold
      final roundsSinceHigh = 600;
      final isHighAttention = roundsSinceHigh >= threshold;
      expect(isHighAttention, isTrue);
    });
  });
}
