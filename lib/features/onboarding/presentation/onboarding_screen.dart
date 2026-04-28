import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme.dart';

const _kOnboardingKey = 'onboardingComplete';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.replay = false});

  final bool replay;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  static const _pageCount = 5;

  bool get _isLastPage => _currentPage == _pageCount - 1;

  Future<void> _markComplete() async {
    if (widget.replay) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingKey, true);
  }

  Future<void> _skip() async {
    await _markComplete();
    if (mounted) context.go('/dashboard');
  }

  Future<void> _addFirstFirearm() async {
    await _markComplete();
    if (mounted) context.go('/firearms/add');
  }

  Future<void> _goToDashboard() async {
    await _markComplete();
    if (mounted) context.go('/dashboard');
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  _WelcomePage(),
                  _OwnershipPage(),
                  _SessionsPage(),
                  _PerformancePage(),
                  _SetupPage(),
                ],
              ),
            ),
            _BottomControls(
              currentPage: _currentPage,
              pageCount: _pageCount,
              isLastPage: _isLastPage,
              skipLabel: widget.replay ? 'Done' : 'Skip',
              onNext: _next,
              onSkip: _skip,
              onAddFirearm: _addFirstFirearm,
              onDashboard: _goToDashboard,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pages ─────────────────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: RoundCountTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.shield,
              size: 44,
              color: RoundCountTheme.accent,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'RoundCount',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Your private firearm performance record.',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: RoundCountTheme.accent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Track firearms, ammo, range sessions, malfunctions, cost, '
            'and maintenance history in one local-first app.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OwnershipPage extends StatelessWidget {
  const _OwnershipPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: RoundCountTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 36,
                color: RoundCountTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Build your ownership record',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add firearms and ammo inventory so every range trip updates '
            'lifetime round counts, ammo on hand, and ammo burn.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _HighlightCard(
            items: const [
              _HighlightItem(
                icon: Icons.my_location,
                label: 'Firearm round counts',
              ),
              _HighlightItem(
                icon: Icons.inventory_2_outlined,
                label: 'Ammo inventory',
              ),
              _HighlightItem(
                icon: Icons.attach_money,
                label: 'Cost-per-round tracking',
              ),
              _HighlightItem(
                icon: Icons.notes_outlined,
                label: 'Ownership notes',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionsPage extends StatelessWidget {
  const _SessionsPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: RoundCountTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.timer_outlined,
                size: 36,
                color: RoundCountTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Turn range trips into data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A session records what you shot, how many rounds you fired, '
            'which ammo you used, and any malfunctions or notes.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RoundCountTheme.surfaceFor(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.fromBorderSide(
                BorderSide(color: RoundCountTheme.borderFor(context)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOGGING FLOW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: RoundCountTheme.textSecondaryFor(context),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _FlowChip(label: 'Session'),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: RoundCountTheme.textSecondaryFor(context)
                          .withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 6),
                    _FlowChip(label: 'Firearm Run'),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: RoundCountTheme.textSecondaryFor(context)
                          .withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 6),
                    _FlowChip(label: 'Summary'),
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

class _PerformancePage extends StatelessWidget {
  const _PerformancePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: RoundCountTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 36,
                color: RoundCountTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Review performance signals',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'RoundCount turns your logged data into performance records, '
            'reliability signals, ammo burn, and maintenance history over time.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _HighlightCard(
            items: const [
              _HighlightItem(
                icon: Icons.analytics_outlined,
                label: 'Performance record per firearm',
              ),
              _HighlightItem(
                icon: Icons.verified_outlined,
                label: 'Reliability signals over time',
              ),
              _HighlightItem(
                icon: Icons.attach_money,
                label: 'Ammo burn and cost tracking',
              ),
              _HighlightItem(
                icon: Icons.build_outlined,
                label: 'Maintenance history',
              ),
            ],
          ),
          const SizedBox(height: 20),
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
              'Based on logged data. RoundCount does not certify firearm '
              'safety or reliability.',
              style: TextStyle(
                fontSize: 12,
                color: RoundCountTheme.textSecondaryFor(context)
                    .withValues(alpha: 0.75),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupPage extends StatelessWidget {
  const _SetupPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: RoundCountTheme.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.flag_outlined,
                size: 36,
                color: RoundCountTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Start in three steps',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up RoundCount in minutes.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
          ),
          const SizedBox(height: 28),
          _StepRow(number: '1', title: 'Add your first firearm'),
          const SizedBox(height: 16),
          _StepRow(number: '2', title: 'Add ammo inventory'),
          const SizedBox(height: 16),
          _StepRow(number: '3', title: 'Start your first session'),
        ],
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────────────────────

class _HighlightItem {
  const _HighlightItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.items});

  final List<_HighlightItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = item == items.last;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: RoundCountTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(item.icon,
                      size: 15, color: RoundCountTheme.accent),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: RoundCountTheme.textPrimaryFor(context),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FlowChip extends StatelessWidget {
  const _FlowChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: RoundCountTheme.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.accent.withValues(alpha: 0.25)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: RoundCountTheme.accent,
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.title});

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: RoundCountTheme.accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: RoundCountTheme.accent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bottom controls ────────────────────────────────────────────────────────────

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.currentPage,
    required this.pageCount,
    required this.isLastPage,
    required this.skipLabel,
    required this.onNext,
    required this.onSkip,
    required this.onAddFirearm,
    required this.onDashboard,
  });

  final int currentPage;
  final int pageCount;
  final bool isLastPage;
  final String skipLabel;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onAddFirearm;
  final VoidCallback onDashboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageCount,
              (i) => _Dot(active: i == currentPage),
            ),
          ),
          const SizedBox(height: 20),
          if (!isLastPage) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: RoundCountTheme.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: RoundCountTheme.textSecondaryFor(context),
              ),
              child: Text(
                skipLabel,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: onAddFirearm,
                style: FilledButton.styleFrom(
                  backgroundColor: RoundCountTheme.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Add First Firearm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: onDashboard,
              style: TextButton.styleFrom(
                foregroundColor: RoundCountTheme.textSecondaryFor(context),
              ),
              child: const Text(
                'Go to Dashboard',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active
            ? RoundCountTheme.accent
            : RoundCountTheme.textSecondaryFor(context).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
