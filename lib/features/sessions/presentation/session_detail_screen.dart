import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../../ammo/providers/ammo_providers.dart';
import '../../firearms/providers/firearm_providers.dart';
import '../providers/session_providers.dart';

class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (session) {
          if (session == null) {
            return Center(
              child: Text(
                'Session not found',
                style: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context)),
              ),
            );
          }
          return _SessionDetail(session: session, sessionId: id);
        },
      ),
    );
  }
}

class _SessionDetail extends ConsumerWidget {
  const _SessionDetail({required this.session, required this.sessionId});

  final RangeSession session;
  final String sessionId;

  Future<void> _endSession(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RoundCountTheme.surfaceFor(context),
        title: Text(
          'End Session?',
          style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
        ),
        content: Text(
          'This will mark the session as completed.',
          style: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'End Session',
              style: TextStyle(color: RoundCountTheme.accent),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(sessionRepositoryProvider).endSession(sessionId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runsAsync = ref.watch(runsForSessionProvider(sessionId));
    final firearmsAsync = ref.watch(firearmsProvider);
    final ammoAsync = ref.watch(ammoProductsProvider);

    final isActive = session.endedAt == null;

    final firearmMap = firearmsAsync.whenOrNull(
          data: (list) => {for (final f in list) f.id: f},
        ) ??
        {};
    final ammoMap = ammoAsync.whenOrNull(
          data: (list) => {for (final a in list) a.id: a},
        ) ??
        {};

    return Stack(
      children: [
        runsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error: $e',
                style: const TextStyle(color: RoundCountTheme.danger)),
          ),
          data: (runs) {
            // ── Compute summary stats ────────────────────────────────────────
            final totalRounds = runs.fold(0, (s, r) => s + r.roundsFired);
            final totalMalfunctions =
                runs.fold(0, (s, r) => s + r.malfunctionCount);
            final uniqueFirearmIds = runs.map((r) => r.firearmId).toSet();
            final uniqueFirearmCount = uniqueFirearmIds.length;

            final firearmRoundTotals = <String, int>{};
            for (final run in runs) {
              firearmRoundTotals[run.firearmId] =
                  (firearmRoundTotals[run.firearmId] ?? 0) + run.roundsFired;
            }

            final ammoRoundTotals = <String, int>{};
            final ammoCosts = <String, double>{};
            var estimatedCostTotal = 0.0;
            var hasCostData = false;

            for (final run in runs) {
              if (run.ammoProductId != null) {
                final aid = run.ammoProductId!;
                ammoRoundTotals[aid] =
                    (ammoRoundTotals[aid] ?? 0) + run.roundsFired;

                final ammo = ammoMap[aid];
                if (ammo != null &&
                    ammo.costPerBox != null &&
                    ammo.quantityPerBox != null &&
                    ammo.quantityPerBox! > 0) {
                  final costPerRound = ammo.costPerBox! / ammo.quantityPerBox!;
                  final runCost = costPerRound * run.roundsFired;
                  ammoCosts[aid] = (ammoCosts[aid] ?? 0) + runCost;
                  estimatedCostTotal += runCost;
                  hasCostData = true;
                }
              }
            }

            final estimatedCost = hasCostData ? estimatedCostTotal : null;

            // ── Build content ────────────────────────────────────────────────
            return ListView(
              padding:
                  EdgeInsets.fromLTRB(16, 16, 16, isActive ? 200 : 24),
              children: [
                // Hero card — active vs completed (animated on transition)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: isActive
                      ? _ActiveHeroCard(
                          key: const ValueKey('active'),
                          session: session,
                          totalRounds: totalRounds,
                          runCount: runs.length,
                          totalMalfunctions: totalMalfunctions,
                          estimatedCost: estimatedCost,
                        )
                      : _CompletedHeroCard(
                          key: const ValueKey('completed'),
                          session: session,
                          totalRounds: totalRounds,
                          uniqueFirearmCount: uniqueFirearmCount,
                          totalMalfunctions: totalMalfunctions,
                          estimatedCost: estimatedCost,
                        ),
                ),
                const SizedBox(height: 12),

                // Updated by this session — completed sessions with runs only
                if (!isActive && runs.isNotEmpty) ...[
                  _UpdatedBySessionCard(
                    firearmMap: firearmMap,
                    ammoMap: ammoMap,
                    firearmRoundTotals: firearmRoundTotals,
                    ammoRoundTotals: ammoRoundTotals,
                    ammoCosts: ammoCosts,
                  ),
                  const SizedBox(height: 12),
                ],

                // Reliability snapshot — any session with rounds logged
                if (totalRounds > 0) ...[
                  _ReliabilityCard(
                    totalRounds: totalRounds,
                    totalMalfunctions: totalMalfunctions,
                  ),
                  const SizedBox(height: 12),
                ],

                // Firearm runs list
                if (runs.isNotEmpty) ...[
                  _SectionLabel(label: 'Firearm Runs'),
                  const SizedBox(height: 12),
                  ...runs.map((run) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _RunCard(
                          run: run,
                          firearm: firearmMap[run.firearmId],
                          ammo: run.ammoProductId != null
                              ? ammoMap[run.ammoProductId]
                              : null,
                        ),
                      )),
                ] else ...[
                  if (isActive)
                    const _RunsEmptyState()
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          'No runs were logged for this session.',
                          style: TextStyle(
                            fontSize: 15,
                            color: RoundCountTheme.textSecondaryFor(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ],
            );
          },
        ),

        // Bottom action bar — active sessions only
        if (isActive)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: RoundCountTheme.surfaceFor(context),
                border: Border(
                  top: BorderSide(color: RoundCountTheme.borderFor(context)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.push('/sessions/$sessionId/add-run'),
                          style: FilledButton.styleFrom(
                            backgroundColor: RoundCountTheme.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Run',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => _endSession(context, ref),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: RoundCountTheme.danger,
                            side: const BorderSide(
                                color: RoundCountTheme.danger, width: 1.5),
                            backgroundColor:
                                RoundCountTheme.danger.withValues(alpha: 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'End Session',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: RoundCountTheme.danger,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Active session hero card ──────────────────────────────────────────────────

class _ActiveHeroCard extends StatelessWidget {
  const _ActiveHeroCard({
    super.key,
    required this.session,
    required this.totalRounds,
    required this.runCount,
    required this.totalMalfunctions,
    this.estimatedCost,
  });

  final RangeSession session;
  final int totalRounds;
  final int runCount;
  final int totalMalfunctions;
  final double? estimatedCost;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('MMM d, yyyy').format(session.startedAt.toLocal());
    final timeLabel =
        DateFormat('h:mm a').format(session.startedAt.toLocal());
    final costLabel =
        estimatedCost != null ? '\$${estimatedCost!.toStringAsFixed(2)}' : '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: RoundCountTheme.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.timer,
                    color: RoundCountTheme.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Training Log',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: RoundCountTheme.textPrimaryFor(context),
                        ),
                      ),
                      Text(
                        '$dateLabel · $timeLabel',
                        style: TextStyle(
                          fontSize: 12,
                          color: RoundCountTheme.textSecondaryFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const _StatusChip(isActive: true),
              ],
            ),
            const SizedBox(height: 16),
            Row(children: [
              _StatBox(
                value: '$totalRounds',
                label: 'Rounds',
                icon: Icons.my_location,
              ),
              const SizedBox(width: 10),
              _StatBox(
                value: '$runCount',
                label: runCount == 1 ? 'Run' : 'Runs',
                icon: Icons.shield_outlined,
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _StatBox(
                value: '$totalMalfunctions',
                label: 'Malfunctions',
                icon: Icons.warning_amber_rounded,
                iconColor: totalMalfunctions > 0
                    ? RoundCountTheme.warning
                    : null,
              ),
              const SizedBox(width: 10),
              _StatBox(
                value: costLabel,
                label: 'Est. Cost',
                icon: Icons.attach_money,
              ),
            ]),
            if (estimatedCost == null) ...[
              const SizedBox(height: 8),
              Text(
                'Add ammo cost data to estimate session spend.',
                style: TextStyle(
                  fontSize: 11,
                  color: RoundCountTheme.textSecondaryFor(context)
                      .withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Divider(color: RoundCountTheme.borderFor(context)),
            const SizedBox(height: 12),
            Text(
              'Each run you add updates your firearm and ammo records immediately.',
              style: TextStyle(
                fontSize: 13,
                color: RoundCountTheme.textSecondaryFor(context),
                height: 1.4,
              ),
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '“${session.notes!}”',
                style: TextStyle(
                  fontSize: 13,
                  color: RoundCountTheme.textSecondaryFor(context),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Completed session hero card ───────────────────────────────────────────────

class _CompletedHeroCard extends StatelessWidget {
  const _CompletedHeroCard({
    super.key,
    required this.session,
    required this.totalRounds,
    required this.uniqueFirearmCount,
    required this.totalMalfunctions,
    this.estimatedCost,
  });

  final RangeSession session;
  final int totalRounds;
  final int uniqueFirearmCount;
  final int totalMalfunctions;
  final double? estimatedCost;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('MMM d, yyyy').format(session.startedAt.toLocal());
    final timeLabel =
        DateFormat('h:mm a').format(session.startedAt.toLocal());
    final costLabel =
        estimatedCost != null ? '\$${estimatedCost!.toStringAsFixed(2)}' : '—';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: RoundCountTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: RoundCountTheme.success,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Training Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: RoundCountTheme.textPrimaryFor(context),
                        ),
                      ),
                      Text(
                        '$dateLabel · $timeLabel',
                        style: TextStyle(
                          fontSize: 12,
                          color: RoundCountTheme.textSecondaryFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const _StatusChip(isActive: false),
              ],
            ),
            const SizedBox(height: 16),
            Row(children: [
              _StatBox(
                value: '$totalRounds',
                label: 'Rounds Fired',
                icon: Icons.my_location,
              ),
              const SizedBox(width: 10),
              _StatBox(
                value: costLabel,
                label: 'Est. Cost',
                icon: Icons.attach_money,
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _StatBox(
                value: '$uniqueFirearmCount',
                label: uniqueFirearmCount == 1 ? 'Firearm' : 'Firearms',
                icon: Icons.shield_outlined,
              ),
              const SizedBox(width: 10),
              _StatBox(
                value: '$totalMalfunctions',
                label: 'Malfunctions',
                icon: Icons.warning_amber_rounded,
                iconColor: totalMalfunctions > 0
                    ? RoundCountTheme.warning
                    : null,
              ),
            ]),
            if (estimatedCost == null && totalRounds > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Add ammo cost data to estimate session spend.',
                style: TextStyle(
                  fontSize: 11,
                  color: RoundCountTheme.textSecondaryFor(context)
                      .withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Divider(color: RoundCountTheme.borderFor(context)),
            const SizedBox(height: 12),
            Text(
              'RoundCount converted this range trip into firearm history, ammo burn, and reliability data.',
              style: TextStyle(
                fontSize: 13,
                color: RoundCountTheme.textSecondaryFor(context),
                height: 1.4,
              ),
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '“${session.notes!}”',
                style: TextStyle(
                  fontSize: 13,
                  color: RoundCountTheme.textSecondaryFor(context),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Updated by this session card ─────────────────────────────────────────────

class _UpdatedBySessionCard extends StatelessWidget {
  const _UpdatedBySessionCard({
    required this.firearmMap,
    required this.ammoMap,
    required this.firearmRoundTotals,
    required this.ammoRoundTotals,
    required this.ammoCosts,
  });

  final Map<String, Firearm> firearmMap;
  final Map<String, AmmoProduct> ammoMap;
  final Map<String, int> firearmRoundTotals;
  final Map<String, int> ammoRoundTotals;
  final Map<String, double> ammoCosts;

  @override
  Widget build(BuildContext context) {
    final firearmEntries = firearmRoundTotals.entries.toList();
    final ammoEntries = ammoRoundTotals.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RECORDS UPDATED',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondaryFor(context),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            // Firearm round additions
            ...firearmEntries.map((e) {
              final firearm = firearmMap[e.key];
              final label = firearm != null
                  ? '${firearm.brand} ${firearm.model}'
                  : 'Unknown Firearm';
              return _UpdateRow(
                icon: Icons.shield,
                iconColor: RoundCountTheme.accent,
                label: label,
                detail: '+${e.value} lifetime rounds',
                detailColor: RoundCountTheme.accent,
              );
            }),
            // Ammo inventory decrements
            if (ammoEntries.isNotEmpty) ...[
              if (firearmEntries.isNotEmpty)
                Divider(
                    color: RoundCountTheme.borderFor(context), height: 20),
              ...ammoEntries.map((e) {
                final ammo = ammoMap[e.key];
                String label;
                if (ammo != null) {
                  label = '${ammo.brand} ${ammo.caliber}';
                  if (ammo.grain != null) label += ' ${ammo.grain}gr';
                  if (ammo.productLine != null) {
                    label += ' (${ammo.productLine})';
                  }
                } else {
                  label = 'Unknown Ammo';
                }
                final cost = ammoCosts[e.key];
                final detail = cost != null
                    ? '-${e.value} inventory rounds · \$${cost.toStringAsFixed(2)} ammo burn'
                    : '-${e.value} inventory rounds';
                return _UpdateRow(
                  icon: Icons.inventory_2_outlined,
                  iconColor: RoundCountTheme.textSecondaryFor(context),
                  label: label,
                  detail: detail,
                  detailColor: null,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _UpdateRow extends StatelessWidget {
  const _UpdateRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.detail,
    this.detailColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String detail;
  final Color? detailColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textPrimaryFor(context),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            detail,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: detailColor ?? RoundCountTheme.textSecondaryFor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reliability snapshot card ─────────────────────────────────────────────────

class _ReliabilityCard extends StatelessWidget {
  const _ReliabilityCard({
    required this.totalRounds,
    required this.totalMalfunctions,
  });

  final int totalRounds;
  final int totalMalfunctions;

  @override
  Widget build(BuildContext context) {
    final isClean = totalMalfunctions == 0;
    final body = isClean
        ? 'Clean signal — 0 malfunctions across $totalRounds logged rounds.'
        : '$totalMalfunctions ${totalMalfunctions == 1 ? 'malfunction' : 'malfunctions'} across $totalRounds logged rounds. Keep logging to identify firearm, ammo, or maintenance patterns.';

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
                color: isClean
                    ? RoundCountTheme.success.withValues(alpha: 0.12)
                    : RoundCountTheme.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isClean
                    ? Icons.verified_outlined
                    : Icons.warning_amber_rounded,
                color: isClean
                    ? RoundCountTheme.success
                    : RoundCountTheme.warning,
                size: 20,
              ),
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

// ── Shared stat box ───────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: RoundCountTheme.elevatedSurfaceFor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.fromBorderSide(
              BorderSide(color: RoundCountTheme.borderFor(context))),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor ?? RoundCountTheme.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: RoundCountTheme.textPrimaryFor(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: RoundCountTheme.textSecondaryFor(context),
                    ),
                    overflow: TextOverflow.ellipsis,
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

// ── Individual firearm run card ───────────────────────────────────────────────

class _RunCard extends StatelessWidget {
  const _RunCard({
    required this.run,
    required this.firearm,
    required this.ammo,
  });

  final FirearmRun run;
  final Firearm? firearm;
  final AmmoProduct? ammo;

  @override
  Widget build(BuildContext context) {
    final firearmLabel = firearm != null
        ? '${firearm!.brand} ${firearm!.model}'
        : 'Unknown Firearm';

    String? ammoLabel;
    if (ammo != null) {
      ammoLabel = '${ammo!.brand} ${ammo!.caliber}';
      if (ammo!.grain != null) ammoLabel += ' ${ammo!.grain}gr';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: RoundCountTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shield,
                    color: RoundCountTheme.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firearmLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: RoundCountTheme.textPrimaryFor(context),
                        ),
                      ),
                      if (ammoLabel != null)
                        Text(
                          ammoLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: RoundCountTheme.textSecondaryFor(context),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${run.roundsFired} rds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: RoundCountTheme.textPrimaryFor(context),
                      ),
                    ),
                    if (run.malfunctionCount > 0)
                      Text(
                        '${run.malfunctionCount} mal.',
                        style: const TextStyle(
                          fontSize: 11,
                          color: RoundCountTheme.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (run.notes != null && run.notes!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Divider(color: RoundCountTheme.borderFor(context)),
              const SizedBox(height: 8),
              Text(
                run.notes!,
                style: TextStyle(
                  fontSize: 13,
                  color: RoundCountTheme.textSecondaryFor(context),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? RoundCountTheme.accent.withValues(alpha: 0.12)
            : RoundCountTheme.elevatedSurfaceFor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.fromBorderSide(
          BorderSide(
            color: isActive
                ? RoundCountTheme.accent.withValues(alpha: 0.4)
                : RoundCountTheme.borderFor(context),
          ),
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Completed',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isActive
              ? RoundCountTheme.accent
              : RoundCountTheme.textSecondaryFor(context),
        ),
      ),
    );
  }
}

// ── Empty state (active session, no runs yet) ─────────────────────────────────

class _RunsEmptyState extends StatelessWidget {
  const _RunsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add your first firearm run',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: RoundCountTheme.textPrimaryFor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A firearm run records one firearm and ammo combination during this session.',
              style: TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textSecondaryFor(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'e.g. Ruger RXM 4.5 + Blazer 124gr FMJ + 50 rounds',
              style: TextStyle(
                fontSize: 13,
                color: RoundCountTheme.textSecondaryFor(context)
                    .withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: RoundCountTheme.textSecondaryFor(context),
        letterSpacing: 1.2,
      ),
    );
  }
}
