import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../data/dashboard_models.dart';
import '../providers/dashboard_providers.dart';

final _numFmt = NumberFormat.decimalPattern();
final _dateFmt = DateFormat('MMM d, yyyy');

String _n(int n) => _numFmt.format(n);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RoundCount',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Unable to load dashboard')),
        data: (summary) => _DashboardBody(summary: summary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Your private firearm performance record.',
              style: TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textSecondaryFor(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _OwnershipSnapshotCard(summary: summary),
          const SizedBox(height: 12),
          _RecentTrainingCard(summary: summary),
          const SizedBox(height: 12),
          _MaintenanceWatchCard(summary: summary),
          const SizedBox(height: 12),
          _ReliabilitySignalsCard(summary: summary),
          const SizedBox(height: 12),
          const _QuickActionsCard(),
          if (summary.isEmpty) ...[
            const SizedBox(height: 12),
            const _GettingStartedCard(),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared card shell
// ─────────────────────────────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  const _DashCard({required this.title, required this.child, this.icon});

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 14,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ownership Snapshot
// ─────────────────────────────────────────────────────────────────────────────

class _OwnershipSnapshotCard extends StatelessWidget {
  const _OwnershipSnapshotCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final ammoValue =
        summary.totalAmmoOnHand != null ? _n(summary.totalAmmoOnHand!) : '—';
    final ammoLabel =
        summary.totalAmmoOnHand != null ? 'rounds on hand' : 'Inventory not set';

    return _DashCard(
      title: 'Ownership Snapshot',
      icon: Icons.bar_chart_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: _n(summary.totalFirearms),
                  label:
                      summary.totalFirearms == 1 ? 'firearm' : 'firearms',
                ),
              ),
              Expanded(
                child: _StatTile(
                  value: _n(summary.lifetimeRounds),
                  label: 'lifetime rounds',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatTile(value: ammoValue, label: ammoLabel),
              ),
              Expanded(
                child: _StatTile(
                  value: _n(summary.totalSessions),
                  label:
                      summary.totalSessions == 1 ? 'session' : 'sessions',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: RoundCountTheme.textPrimaryFor(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: RoundCountTheme.textSecondaryFor(context),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent Training
// ─────────────────────────────────────────────────────────────────────────────

class _RecentTrainingCard extends StatelessWidget {
  const _RecentTrainingCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final session = summary.recentSession;
    return _DashCard(
      title: 'Recent Training',
      icon: Icons.timer_outlined,
      child: session == null
          ? _EmptyState(
              title: 'No training sessions yet',
              body: 'Start logging range trips to build your firearm'
                  ' performance record.',
              buttonLabel: 'Start Tracking',
              onTap: () => context.push('/sessions/start'),
            )
          : _RecentSessionContent(summary: summary),
    );
  }
}

class _RecentSessionContent extends StatelessWidget {
  const _RecentSessionContent({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final session = summary.recentSession!;
    final dateStr = _dateFmt.format(session.startedAt.toLocal());
    final rounds = summary.recentSessionRounds;
    final malfs = summary.recentSessionMalfunctions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateStr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: RoundCountTheme.textPrimaryFor(context),
          ),
        ),
        const SizedBox(height: 8),
        if (rounds > 0)
          _InfoRow(
            icon: Icons.radio_button_checked_outlined,
            text: '${_n(rounds)} rounds logged',
          ),
        if (malfs > 0)
          _InfoRow(
            icon: Icons.warning_amber_outlined,
            text: '$malfs ${malfs == 1 ? 'malfunction' : 'malfunctions'}',
            color: RoundCountTheme.warning,
          ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => context.push('/sessions/${session.id}'),
          style: OutlinedButton.styleFrom(
            foregroundColor: RoundCountTheme.accent,
            side: const BorderSide(color: RoundCountTheme.accent),
          ),
          child: const Text('View Session'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? RoundCountTheme.textSecondaryFor(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 14, color: c)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Maintenance Watch
// ─────────────────────────────────────────────────────────────────────────────

class _MaintenanceWatchCard extends StatelessWidget {
  const _MaintenanceWatchCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = summary.maintenanceAttentionItems;

    Widget content;
    if (summary.totalFirearms == 0) {
      content = const _BodyText(
        'Add a firearm to begin building a maintenance record.',
      );
    } else if (items.isEmpty) {
      content = const _BodyText(
        'No maintenance attention items based on logged data.',
      );
    } else {
      final shown = items.take(3).toList();
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...shown.map((item) => _MaintenanceRow(item: item)),
          if (items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '+${items.length - 3} more — view Armory for full list',
                style: TextStyle(
                  fontSize: 13,
                  color: RoundCountTheme.textSecondaryFor(context),
                ),
              ),
            ),
        ],
      );
    }

    return _DashCard(
      title: 'Maintenance Watch',
      icon: Icons.build_outlined,
      child: content,
    );
  }
}

class _MaintenanceRow extends StatelessWidget {
  const _MaintenanceRow({required this.item});

  final MaintenanceAttentionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/firearms/${item.firearm.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: RoundCountTheme.warning,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.firearm.brand} ${item.firearm.model}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: RoundCountTheme.textPrimaryFor(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.statusLine,
                    style: TextStyle(
                      fontSize: 13,
                      color: RoundCountTheme.textSecondaryFor(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reliability Signals
// ─────────────────────────────────────────────────────────────────────────────

class _ReliabilitySignalsCard extends StatelessWidget {
  const _ReliabilitySignalsCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final malfs = summary.totalMalfunctions;

    final String body;
    final Color? bodyColor;

    if (summary.totalRuns == 0) {
      body = 'Log firearm runs to build reliability history over time.';
      bodyColor = null;
    } else if (malfs == 0) {
      body =
          'Clean signal — 0 malfunctions across logged firearm history.';
      bodyColor = RoundCountTheme.accent;
    } else {
      body =
          '${_n(malfs)} ${malfs == 1 ? 'malfunction' : 'malfunctions'} logged.'
          ' Review firearm records to identify firearm, ammo, or maintenance'
          ' patterns.';
      bodyColor = RoundCountTheme.warning;
    }

    return _DashCard(
      title: 'Reliability Signals',
      icon: Icons.verified_outlined,
      child: Text(
        body,
        style: TextStyle(
          fontSize: 14,
          color: bodyColor ?? RoundCountTheme.textSecondaryFor(context),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Quick Actions',
      icon: Icons.flash_on_outlined,
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Icons.timer_outlined,
              label: 'Start\nSession',
              onTap: () => context.push('/sessions/start'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Icons.shield_outlined,
              label: 'Add\nFirearm',
              onTap: () => context.push('/firearms/add'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Icons.inventory_2_outlined,
              label: 'Add\nAmmo',
              onTap: () => context.push('/ammo/add'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: RoundCountTheme.elevatedSurfaceFor(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: RoundCountTheme.accent, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: RoundCountTheme.textPrimaryFor(context),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Getting Started (empty install)
// ─────────────────────────────────────────────────────────────────────────────

class _GettingStartedCard extends StatelessWidget {
  const _GettingStartedCard();

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Get Started',
      icon: Icons.rocket_launch_outlined,
      child: Column(
        children: const [
          _SetupStep(number: 1, text: 'Add your first firearm'),
          _SetupStep(number: 2, text: 'Add ammo inventory'),
          _SetupStep(number: 3, text: 'Start tracking sessions'),
        ],
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: RoundCountTheme.accent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    this.title,
    required this.body,
    required this.buttonLabel,
    required this.onTap,
  });

  final String? title;
  final String body;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          body,
          style: TextStyle(
            fontSize: 14,
            color: RoundCountTheme.textSecondaryFor(context),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: RoundCountTheme.accent,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  const _BodyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: RoundCountTheme.textSecondaryFor(context),
      ),
    );
  }
}
