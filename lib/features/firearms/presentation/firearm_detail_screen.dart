import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../../ammo/providers/ammo_providers.dart';
import '../../sessions/providers/session_providers.dart';
import '../data/firearm_performance_summary.dart';
import '../providers/firearm_providers.dart';

class FirearmDetailScreen extends ConsumerWidget {
  const FirearmDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firearmAsync = ref.watch(firearmByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: firearmAsync.when(
          data: (f) => Text(
            f != null ? '${f.brand} ${f.model}' : 'Firearm',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          loading: () => const Text(''),
          error: (error, _) => const Text('Firearm'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push('/firearms/$id/edit'),
          ),
        ],
      ),
      body: firearmAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (firearm) {
          if (firearm == null) {
            return Center(
              child: Text(
                'Firearm not found',
                style: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context)),
              ),
            );
          }
          return _FirearmDetail(firearm: firearm);
        },
      ),
    );
  }
}

class _FirearmDetail extends ConsumerWidget {
  const _FirearmDetail({required this.firearm});

  final Firearm firearm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runsAsync = ref.watch(runsForFirearmProvider(firearm.id));
    final sessionsAsync = ref.watch(sessionsProvider);
    final ammoAsync = ref.watch(ammoProductsProvider);

    // Compute performance summary from available data; null while any stream loads.
    final summary = runsAsync.whenOrNull(
      data: (runs) {
        final sessions = sessionsAsync.whenOrNull(data: (s) => s) ?? [];
        final ammoList = ammoAsync.whenOrNull(data: (a) => a) ?? [];

        final totalRuns = runs.length;
        final totalSessions = runs.map((r) => r.sessionId).toSet().length;
        final totalMalfunctions =
            runs.fold(0, (s, r) => s + r.malfunctionCount);

        // Last session date — find the most-recent session that includes this firearm.
        final sessionIds = runs.map((r) => r.sessionId).toSet();
        DateTime? lastSessionDate;
        if (sessionIds.isNotEmpty) {
          final relevant =
              sessions.where((s) => sessionIds.contains(s.id)).toList();
          if (relevant.isNotEmpty) {
            relevant.sort((a, b) => b.startedAt.compareTo(a.startedAt));
            lastSessionDate = relevant.first.startedAt;
          }
        }

        // Estimated ammo cost across all runs.
        final ammoMap = {for (final a in ammoList) a.id: a};
        var costTotal = 0.0;
        var hasCost = false;
        for (final run in runs) {
          if (run.ammoProductId != null) {
            final ammo = ammoMap[run.ammoProductId];
            if (ammo != null &&
                ammo.costPerBox != null &&
                ammo.quantityPerBox != null &&
                ammo.quantityPerBox! > 0) {
              final costPerRound = ammo.costPerBox! / ammo.quantityPerBox!;
              costTotal += costPerRound * run.roundsFired;
              hasCost = true;
            }
          }
        }

        return FirearmPerformanceSummary(
          lifetimeRounds: firearm.totalRounds,
          totalRuns: totalRuns,
          totalSessions: totalSessions,
          totalMalfunctions: totalMalfunctions,
          lastSessionDate: lastSessionDate,
          estimatedAmmoCost: hasCost ? costTotal : null,
        );
      },
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _HeroCard(firearm: firearm),
        const SizedBox(height: 16),
        _InfoSection(
          title: 'Specifications',
          items: [
            _InfoItem(label: 'Brand', value: firearm.brand),
            _InfoItem(label: 'Model', value: firearm.model),
            _InfoItem(label: 'Caliber', value: firearm.caliber),
            _InfoItem(label: 'Class', value: firearm.firearmClass),
            if (firearm.serialNumber != null)
              _InfoItem(label: 'Serial Number', value: firearm.serialNumber!),
          ],
        ),
        const SizedBox(height: 16),
        _PerformanceRecord(
          firearm: firearm,
          summary: summary,
          isLoading: runsAsync is AsyncLoading,
        ),
      ],
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.firearm});

  final Firearm firearm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: RoundCountTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.shield,
                color: RoundCountTheme.accent,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firearm.brand,
                    style: TextStyle(
                      fontSize: 13,
                      color: RoundCountTheme.textSecondaryFor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    firearm.model,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: RoundCountTheme.textPrimaryFor(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill(label: firearm.caliber),
                      const SizedBox(width: 8),
                      _Pill(label: firearm.firearmClass),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: RoundCountTheme.elevatedSurfaceFor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: RoundCountTheme.textSecondaryFor(context),
        ),
      ),
    );
  }
}

// ── Specifications section ────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.items});

  final String title;
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondaryFor(context),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _InfoRow(item: item)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: TextStyle(
              fontSize: 14,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
          ),
          Text(
            item.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;
}

// ── Performance record ────────────────────────────────────────────────────────

class _PerformanceRecord extends StatelessWidget {
  const _PerformanceRecord({
    required this.firearm,
    required this.summary,
    required this.isLoading,
  });

  final Firearm firearm;
  final FirearmPerformanceSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatsCard(firearm: firearm, summary: summary, isLoading: isLoading),
        const SizedBox(height: 12),
        _ReliabilityCard(summary: summary, isLoading: isLoading),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.firearm,
    required this.summary,
    required this.isLoading,
  });

  final Firearm firearm;
  final FirearmPerformanceSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final dash = isLoading ? '…' : '—';

    final sessionsLabel =
        summary != null ? '${summary!.totalSessions}' : dash;
    final malfunctionsLabel =
        summary != null ? '${summary!.totalMalfunctions}' : dash;
    final malfunctionsColor = (summary != null && summary!.totalMalfunctions > 0)
        ? RoundCountTheme.warning
        : RoundCountTheme.textPrimaryFor(context);

    String lastUsedLabel = dash;
    if (summary != null) {
      lastUsedLabel = summary!.lastSessionDate != null
          ? DateFormat('MMM d, yyyy')
              .format(summary!.lastSessionDate!.toLocal())
          : 'Never';
    }

    String ammoBurnLabel = dash;
    String? ammoBurnHint;
    if (summary != null) {
      if (summary!.estimatedAmmoCost != null) {
        ammoBurnLabel =
            '\$${summary!.estimatedAmmoCost!.toStringAsFixed(2)}';
      } else if (summary!.totalRuns > 0) {
        ammoBurnLabel = '—';
        ammoBurnHint = 'Add ammo cost data to estimate ammo burn.';
      } else {
        ammoBurnLabel = '—';
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PERFORMANCE RECORD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondaryFor(context),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.my_location,
              iconColor: RoundCountTheme.accent,
              label: 'Lifetime Rounds',
              value: '${firearm.totalRounds}',
              valueColor: RoundCountTheme.accent,
            ),
            _StatRow(
              icon: Icons.timer_outlined,
              iconColor: RoundCountTheme.textSecondaryFor(context),
              label: 'Training Sessions',
              value: sessionsLabel,
            ),
            _StatRow(
              icon: Icons.warning_amber_rounded,
              iconColor: summary != null && summary!.totalMalfunctions > 0
                  ? RoundCountTheme.warning
                  : RoundCountTheme.textSecondaryFor(context),
              label: 'Malfunctions',
              value: malfunctionsLabel,
              valueColor:
                  summary != null && summary!.totalMalfunctions > 0
                      ? malfunctionsColor
                      : null,
            ),
            _StatRow(
              icon: Icons.calendar_today_outlined,
              iconColor: RoundCountTheme.textSecondaryFor(context),
              label: 'Last Used',
              value: lastUsedLabel,
            ),
            _StatRow(
              icon: Icons.attach_money,
              iconColor: RoundCountTheme.textSecondaryFor(context),
              label: 'Estimated Ammo Burn',
              value: ammoBurnLabel,
              isLast: ammoBurnHint == null,
            ),
            if (ammoBurnHint != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Text(
                  ammoBurnHint,
                  style: TextStyle(
                    fontSize: 11,
                    color: RoundCountTheme.textSecondaryFor(context)
                        .withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = true,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textSecondaryFor(context),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? RoundCountTheme.textPrimaryFor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reliability signal card ───────────────────────────────────────────────────

class _ReliabilityCard extends StatelessWidget {
  const _ReliabilityCard({required this.summary, required this.isLoading});

  final FirearmPerformanceSummary? summary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color iconBg;
    final Color iconColor;
    final IconData iconData;
    final String body;

    if (isLoading || summary == null) {
      iconBg = RoundCountTheme.textSecondaryFor(context).withValues(alpha: 0.1);
      iconColor = RoundCountTheme.textSecondaryFor(context);
      iconData = Icons.shield_outlined;
      body = 'Loading reliability history…';
    } else if (summary!.totalRuns == 0) {
      iconBg = RoundCountTheme.textSecondaryFor(context).withValues(alpha: 0.1);
      iconColor = RoundCountTheme.textSecondaryFor(context);
      iconData = Icons.shield_outlined;
      body =
          'Start logging sessions to build a reliability history for this firearm.';
    } else if (summary!.totalMalfunctions == 0) {
      iconBg = RoundCountTheme.success.withValues(alpha: 0.12);
      iconColor = RoundCountTheme.success;
      iconData = Icons.verified_outlined;
      body =
          'Clean signal — 0 malfunctions across ${summary!.lifetimeRounds} logged rounds.';
    } else {
      iconBg = RoundCountTheme.warning.withValues(alpha: 0.12);
      iconColor = RoundCountTheme.warning;
      iconData = Icons.warning_amber_rounded;
      final m = summary!.totalMalfunctions;
      body =
          '$m ${m == 1 ? 'malfunction' : 'malfunctions'} logged across ${summary!.lifetimeRounds} rounds. '
          'Keep logging to identify firearm, ammo, or maintenance patterns.';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reliability Signal',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: RoundCountTheme.textPrimaryFor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 13,
                      color: RoundCountTheme.textSecondaryFor(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
