class FirearmPerformanceSummary {
  const FirearmPerformanceSummary({
    required this.lifetimeRounds,
    required this.totalRuns,
    required this.totalSessions,
    required this.totalMalfunctions,
    this.lastSessionDate,
    this.estimatedAmmoCost,
  });

  final int lifetimeRounds;
  final int totalRuns;
  final int totalSessions;
  final int totalMalfunctions;
  final DateTime? lastSessionDate;
  final double? estimatedAmmoCost;
}
