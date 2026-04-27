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
        error: (err, stack) =>
            const Center(child: Text('Unable to load dashboard')),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: [
          const _DashHero(),
          const SizedBox(height: 16),
          _FadeIn(child: _OwnershipSnapshotCard(summary: summary)),
          const SizedBox(height: 12),
          _FadeIn(
            delay: const Duration(milliseconds: 60),
            child: _RecentTrainingCard(summary: summary),
          ),
          const SizedBox(height: 12),
          _FadeIn(
            delay: const Duration(milliseconds: 120),
            child: _MaintenanceWatchCard(summary: summary),
          ),
          const SizedBox(height: 12),
          _FadeIn(
            delay: const Duration(milliseconds: 180),
            child: _ReliabilitySignalsCard(summary: summary),
          ),
          const SizedBox(height: 12),
          _FadeIn(
            delay: const Duration(milliseconds: 220),
            child: const _QuickActionsCard(),
          ),
          if (summary.isEmpty) ...[
            const SizedBox(height: 12),
            _FadeIn(
              delay: const Duration(milliseconds: 260),
              child: const _GettingStartedCard(),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard hero header
// ─────────────────────────────────────────────────────────────────────────────

class _DashHero extends StatelessWidget {
  const _DashHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: RoundCountTheme.accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: RoundCountTheme.accent.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 54,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: RoundCountTheme.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your private firearm\nperformance record.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.32,
                    color: RoundCountTheme.textPrimaryFor(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track every round, session, and reliability signal.',
                  style: TextStyle(
                    fontSize: 13,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ],
            ),
          ),
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
                  Icon(icon, size: 14, color: RoundCountTheme.accent),
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
// Ownership Snapshot — primary data card
// ─────────────────────────────────────────────────────────────────────────────

class _OwnershipSnapshotCard extends StatelessWidget {
  const _OwnershipSnapshotCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final ammoValue =
        summary.totalAmmoOnHand != null ? _n(summary.totalAmmoOnHand!) : '—';
    final ammoLabel = summary.totalAmmoOnHand != null
        ? 'rounds on hand'
        : 'inventory not set';

    return Container(
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: RoundCountTheme.accent.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent header strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: RoundCountTheme.accent.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bar_chart_outlined,
                    size: 14, color: RoundCountTheme.accent),
                const SizedBox(width: 6),
                Text(
                  'OWNERSHIP SNAPSHOT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ],
            ),
          ),
          // 2×2 stat box grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        icon: Icons.shield_outlined,
                        value: _n(summary.totalFirearms),
                        label: summary.totalFirearms == 1
                            ? 'firearm'
                            : 'firearms',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatBox(
                        icon: Icons.radio_button_checked_outlined,
                        value: _n(summary.lifetimeRounds),
                        label: 'lifetime rounds',
                        valueColor: RoundCountTheme.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        icon: Icons.inventory_2_outlined,
                        value: ammoValue,
                        label: ammoLabel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatBox(
                        icon: Icons.timer_outlined,
                        value: _n(summary.totalSessions),
                        label: summary.totalSessions == 1
                            ? 'session'
                            : 'sessions',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RoundCountTheme.elevatedSurfaceFor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RoundCountTheme.borderFor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: RoundCountTheme.accent),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor ?? RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
        // Date
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 13,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
            const SizedBox(width: 6),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: RoundCountTheme.textPrimaryFor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Stat pills
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            if (rounds > 0)
              _StatPill(
                icon: Icons.radio_button_checked_outlined,
                label: '${_n(rounds)} rounds',
              ),
            if (malfs > 0)
              _StatPill(
                icon: Icons.warning_amber_outlined,
                label: '$malfs ${malfs == 1 ? 'malfunction' : 'malfunctions'}',
                color: RoundCountTheme.warning,
              ),
            if (rounds == 0 && malfs == 0)
              _StatPill(
                icon: Icons.notes_outlined,
                label: 'No runs logged yet',
              ),
          ],
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

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? RoundCountTheme.textSecondaryFor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: c),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: c,
            ),
          ),
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
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: RoundCountTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 22,
              color: RoundCountTheme.accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'No maintenance attention needed based on logged data.',
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: RoundCountTheme.textSecondaryFor(context),
              ),
            ),
          ),
        ],
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
    final IconData badgeIcon;
    final Color badgeColor;

    if (summary.totalRuns == 0) {
      body = 'Log firearm runs to build reliability history over time.';
      bodyColor = null;
      badgeIcon = Icons.radio_button_unchecked;
      badgeColor = RoundCountTheme.textSecondaryFor(context);
    } else if (malfs == 0) {
      body = 'Clean signal — 0 malfunctions across logged firearm history.';
      bodyColor = RoundCountTheme.accent;
      badgeIcon = Icons.check_circle_outline;
      badgeColor = RoundCountTheme.accent;
    } else {
      body = '${_n(malfs)} ${malfs == 1 ? 'malfunction' : 'malfunctions'} logged.'
          ' Review firearm records to identify patterns.';
      bodyColor = RoundCountTheme.warning;
      badgeIcon = Icons.warning_amber_outlined;
      badgeColor = RoundCountTheme.warning;
    }

    return _DashCard(
      title: 'Reliability Signals',
      icon: Icons.verified_outlined,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(badgeIcon, size: 22, color: badgeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              body,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: bodyColor ?? RoundCountTheme.textSecondaryFor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick Actions — Start Session primary, Firearm/Ammo secondary
// ─────────────────────────────────────────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Quick Actions',
      icon: Icons.flash_on_outlined,
      child: Column(
        children: [
          // Primary action — Start Session
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () => context.push('/sessions/start'),
              icon: const Icon(Icons.timer_outlined, size: 18),
              label: const Text('Start Session'),
              style: FilledButton.styleFrom(
                backgroundColor: RoundCountTheme.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Secondary actions row
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.shield_outlined,
                  label: 'Add Firearm',
                  onTap: () => context.push('/firearms/add'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: Icons.inventory_2_outlined,
                  label: 'Add Ammo',
                  onTap: () => context.push('/ammo/add'),
                ),
              ),
            ],
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: RoundCountTheme.borderFor(context)),
          ),
          child: Column(
            children: [
              Icon(icon, color: RoundCountTheme.accent, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: RoundCountTheme.textPrimaryFor(context),
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
// Getting Started — empty/fresh install guidance
// ─────────────────────────────────────────────────────────────────────────────

class _GettingStartedCard extends StatelessWidget {
  const _GettingStartedCard();

  @override
  Widget build(BuildContext context) {
    return _DashCard(
      title: 'Get Started',
      icon: Icons.rocket_launch_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Three steps to your first performance record.',
            style: TextStyle(
              fontSize: 14,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
          ),
          const SizedBox(height: 16),
          const _SetupStep(
            number: 1,
            text: 'Add your first firearm',
            sub: 'Brand, model, caliber, and class.',
          ),
          const _SetupStep(
            number: 2,
            text: 'Add ammo inventory',
            sub: 'Track on-hand rounds and cost per box.',
          ),
          const _SetupStep(
            number: 3,
            text: 'Start tracking sessions',
            sub: 'Log rounds, malfunctions, and firearm runs.',
          ),
        ],
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.number,
    required this.text,
    required this.sub,
  });

  final int number;
  final String text;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: RoundCountTheme.textPrimaryFor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 12,
                    color: RoundCountTheme.textSecondaryFor(context),
                  ),
                ),
              ],
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
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: RoundCountTheme.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              buttonLabel,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
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

class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
