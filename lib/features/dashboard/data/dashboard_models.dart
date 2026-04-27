import '../../../data/db/app_database.dart';

class MaintenanceAttentionItem {
  const MaintenanceAttentionItem({
    required this.firearm,
    required this.statusLine,
  });

  final Firearm firearm;
  final String statusLine;
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalFirearms,
    required this.totalAmmoProducts,
    required this.totalAmmoOnHand,
    required this.lifetimeRounds,
    required this.totalRuns,
    required this.totalSessions,
    required this.recentSession,
    required this.recentSessionRounds,
    required this.recentSessionMalfunctions,
    required this.totalMalfunctions,
    required this.maintenanceAttentionItems,
  });

  final int totalFirearms;
  final int totalAmmoProducts;
  final int? totalAmmoOnHand;
  final int lifetimeRounds;
  final int totalRuns;
  final int totalSessions;
  final RangeSession? recentSession;
  final int recentSessionRounds;
  final int recentSessionMalfunctions;
  final int totalMalfunctions;
  final List<MaintenanceAttentionItem> maintenanceAttentionItems;

  bool get isEmpty =>
      totalFirearms == 0 && totalAmmoProducts == 0 && totalSessions == 0;
}
