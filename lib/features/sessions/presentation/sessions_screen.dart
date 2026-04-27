import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../../firearms/providers/firearm_providers.dart';
import '../providers/session_providers.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sessions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/sessions/start'),
        child: const Icon(Icons.add),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (sessions) {
          if (sessions.isEmpty) return const _EmptyState();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Text(
                  'Track every range trip, round count, ammo burn, and reliability signal.',
                  style: TextStyle(
                    fontSize: 14,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ),
              Expanded(child: _SessionList(sessions: sessions)),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firearmsAsync = ref.watch(firearmsProvider);
    // Default to true while loading to avoid flicker toward "Add Firearm"
    final hasFirearms =
        firearmsAsync.whenOrNull(data: (list) => list.isNotEmpty) ?? true;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: RoundCountTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.timer_outlined,
              size: 40,
              color: RoundCountTheme.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Build your firearm performance record',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Every session adds to your private record of rounds fired, ammo used, malfunctions, cost, and firearm history.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RoundCountTheme.elevatedSurfaceFor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.fromBorderSide(
                BorderSide(color: RoundCountTheme.borderFor(context)),
              ),
            ),
            child: Text(
              'RoundCount turns each range trip into useful data for round counts, ammo inventory, reliability patterns, and future maintenance insights.',
              style: TextStyle(
                fontSize: 13,
                color: RoundCountTheme.textSecondaryFor(context),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (hasFirearms) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => context.push('/sessions/start'),
                style: FilledButton.styleFrom(
                  backgroundColor: RoundCountTheme.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Start Tracking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Add a firearm before starting a session.',
              style: TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textSecondaryFor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => context.push('/firearms/add'),
                style: FilledButton.styleFrom(
                  backgroundColor: RoundCountTheme.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Add Firearm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  const _SessionList({required this.sessions});

  final List<RangeSession> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: sessions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _SessionCard(session: sessions[index]),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  const _SessionCard({required this.session});

  final RangeSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runsAsync = ref.watch(runsForSessionProvider(session.id));
    final isActive = session.endedAt == null;

    final runCount = runsAsync.whenOrNull(data: (r) => r.length);
    final totalRounds = runsAsync.whenOrNull(
      data: (r) => r.fold(0, (sum, run) => sum + run.roundsFired),
    );

    final dateLabel =
        DateFormat('MMM d, yyyy').format(session.startedAt.toLocal());

    return Card(
      child: InkWell(
        onTap: () => context.push('/sessions/${session.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? RoundCountTheme.accent.withValues(alpha: 0.12)
                      : RoundCountTheme.textSecondaryFor(context)
                          .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? Icons.timer : Icons.timer_off_outlined,
                  color: isActive
                      ? RoundCountTheme.accent
                      : RoundCountTheme.textSecondaryFor(context),
                  size: 24,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: RoundCountTheme.textPrimaryFor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (runCount != null) ...[
                          Text(
                            '$runCount ${runCount == 1 ? 'run' : 'runs'}',
                            style: TextStyle(
                              fontSize: 13,
                              color: RoundCountTheme.textSecondaryFor(context),
                            ),
                          ),
                          if (totalRounds != null && totalRounds > 0) ...[
                            Text(
                              '  ·  ',
                              style: TextStyle(
                                  color: RoundCountTheme.textSecondaryFor(
                                      context)),
                            ),
                            Text(
                              '$totalRounds rds',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    RoundCountTheme.textSecondaryFor(context),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _StatusChip(isActive: isActive),
            ],
          ),
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
