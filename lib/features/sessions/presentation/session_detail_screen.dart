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
              style: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
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
            final totalRounds =
                runs.fold(0, (sum, r) => sum + r.roundsFired);

            return ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, isActive ? 140 : 24),
              children: [
                _HeroCard(
                  session: session,
                  totalRounds: totalRounds,
                  runCount: runs.length,
                ),
                const SizedBox(height: 16),
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        'No runs yet. Tap Add Run to get started.',
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
        if (isActive)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
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
                      side: BorderSide(
                          color: RoundCountTheme.borderFor(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'End Session',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: RoundCountTheme.textSecondaryFor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.session,
    required this.totalRounds,
    required this.runCount,
  });

  final RangeSession session;
  final int totalRounds;
  final int runCount;

  @override
  Widget build(BuildContext context) {
    final isActive = session.endedAt == null;
    final dateLabel =
        DateFormat('MMM d, yyyy').format(session.startedAt.toLocal());
    final timeLabel =
        DateFormat('h:mm a').format(session.startedAt.toLocal());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isActive
                        ? RoundCountTheme.accent.withValues(alpha: 0.12)
                        : RoundCountTheme.elevatedSurfaceFor(context),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isActive ? Icons.timer : Icons.timer_off_outlined,
                    color: isActive
                        ? RoundCountTheme.accent
                        : RoundCountTheme.textSecondaryFor(context),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: RoundCountTheme.textPrimaryFor(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 13,
                          color: RoundCountTheme.textSecondaryFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(isActive: isActive),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _StatBox(
                  value: '$totalRounds',
                  label: 'Total Rounds',
                  icon: Icons.my_location,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  value: '$runCount',
                  label: runCount == 1 ? 'Run' : 'Runs',
                  icon: Icons.shield_outlined,
                ),
              ],
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: RoundCountTheme.borderFor(context)),
              const SizedBox(height: 12),
              Text(
                session.notes!,
                style: TextStyle(
                  fontSize: 14,
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

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

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
            Icon(icon, size: 18, color: RoundCountTheme.accent),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: RoundCountTheme.textPrimaryFor(context),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: RoundCountTheme.textPrimaryFor(context),
                        ),
                      ),
                      if (ammoLabel != null)
                        Text(
                          ammoLabel,
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
