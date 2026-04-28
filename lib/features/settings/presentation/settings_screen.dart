import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/feedback_mailer.dart';
import '../../../app/theme.dart';
import '../../../app/theme_mode_controller.dart';

// ── Package info provider ──────────────────────────────────────────────────────

final _packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final pkgInfo = ref.watch(_packageInfoProvider);

    void select(ThemeMode m) =>
        ref.read(themeModeProvider.notifier).setMode(m);

    final textPrimary = RoundCountTheme.textPrimaryFor(context);
    final textSecondary = RoundCountTheme.textSecondaryFor(context);
    final surfaceColor = RoundCountTheme.surfaceFor(context);
    final borderColor = RoundCountTheme.borderFor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── 1. Appearance ──────────────────────────────────────────────────
          _SectionHeader(
            title: 'APPEARANCE',
            subtitle: 'Choose a display mode for indoor and outdoor range use.',
          ),
          const SizedBox(height: 16),
          _AppearanceCard(
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            selected: mode,
            onSelect: select,
          ),

          // ── 2. Getting Started ─────────────────────────────────────────────
          const SizedBox(height: 32),
          const _SectionHeader(title: 'GETTING STARTED'),
          const SizedBox(height: 16),
          _SettingsGroup(children: [
            _NavTile(
              icon: Icons.auto_stories_outlined,
              title: 'View onboarding guide',
              subtitle:
                  'Review how RoundCount tracks firearms, ammo, sessions, and maintenance.',
              onTap: () => context.push('/onboarding?replay=true'),
              showDivider: false,
            ),
          ]),

          // ── 3. Privacy & Data ──────────────────────────────────────────────
          const SizedBox(height: 32),
          const _SectionHeader(title: 'PRIVACY & DATA'),
          const SizedBox(height: 16),
          const _PrivacyCard(),

          // ── 4. Feedback ────────────────────────────────────────────────────
          const SizedBox(height: 32),
          const _SectionHeader(
            title: 'FEEDBACK',
            subtitle: 'Help improve RoundCount.',
          ),
          const SizedBox(height: 16),
          _SettingsGroup(children: [
            _NavTile(
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              onTap: () => launchBugReportEmail(context),
              showDivider: true,
            ),
            _NavTile(
              icon: Icons.lightbulb_outlined,
              title: 'Request a Feature',
              onTap: () => launchFeatureRequestEmail(context),
              showDivider: false,
            ),
          ]),

          // ── 5. About ───────────────────────────────────────────────────────
          const SizedBox(height: 32),
          const _SectionHeader(title: 'ABOUT'),
          const SizedBox(height: 16),
          _AboutCard(pkgInfo: pkgInfo),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: RoundCountTheme.textSecondaryFor(context),
            letterSpacing: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: RoundCountTheme.textSecondaryFor(context),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Settings group (card container with clipped ripples) ──────────────────────

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Column(children: children),
    );
  }
}

// ── Nav tile ──────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.showDivider,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final textPrimary = RoundCountTheme.textPrimaryFor(context);
    final textSecondary = RoundCountTheme.textSecondaryFor(context);
    final borderColor = RoundCountTheme.borderFor(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: textSecondary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: borderColor),
      ],
    );
  }
}

// ── Privacy & Data card ────────────────────────────────────────────────────────

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    final textPrimary = RoundCountTheme.textPrimaryFor(context);
    final textSecondary = RoundCountTheme.textSecondaryFor(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: RoundCountTheme.textSecondaryFor(context)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.storage_outlined,
                  size: 16,
                  color: textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Local storage only',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'RoundCount is local-first. Your firearms, ammo, sessions, '
            'and maintenance records are stored on this device.',
            style: TextStyle(
              fontSize: 14,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No account or cloud sync is required in this version.',
            style: TextStyle(
              fontSize: 13,
              color: textSecondary.withValues(alpha: 0.75),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ── About card ────────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.pkgInfo});

  final AsyncValue<PackageInfo> pkgInfo;

  @override
  Widget build(BuildContext context) {
    final textPrimary = RoundCountTheme.textPrimaryFor(context);
    final textSecondary = RoundCountTheme.textSecondaryFor(context);

    final versionLabel = pkgInfo.whenOrNull(
      data: (info) =>
          'Version ${info.version} (Build ${info.buildNumber})',
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: RoundCountTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield,
              color: RoundCountTheme.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RoundCount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Private firearm performance record.',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
                if (versionLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    versionLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Appearance section (unchanged) ────────────────────────────────────────────

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.selected,
    required this.onSelect,
  });

  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final ThemeMode selected;
  final ValueChanged<ThemeMode> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          _OptionTile(
            title: 'System',
            subtitle: 'Match device setting',
            icon: Icons.brightness_auto_outlined,
            value: ThemeMode.system,
            selected: selected,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onSelect: onSelect,
            showDivider: true,
            borderColor: borderColor,
          ),
          _OptionTile(
            title: 'Light',
            subtitle: 'Outdoor / sun-readable',
            icon: Icons.light_mode_outlined,
            value: ThemeMode.light,
            selected: selected,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onSelect: onSelect,
            showDivider: true,
            borderColor: borderColor,
          ),
          _OptionTile(
            title: 'Dark',
            subtitle: 'Indoor / low-glare',
            icon: Icons.dark_mode_outlined,
            value: ThemeMode.dark,
            selected: selected,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onSelect: onSelect,
            showDivider: false,
            borderColor: borderColor,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.selected,
    required this.textPrimary,
    required this.textSecondary,
    required this.onSelect,
    required this.showDivider,
    required this.borderColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode value;
  final ThemeMode selected;
  final Color textPrimary;
  final Color textSecondary;
  final ValueChanged<ThemeMode> onSelect;
  final bool showDivider;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return Column(
      children: [
        InkWell(
          onTap: () => onSelect(value),
          borderRadius: BorderRadius.circular(showDivider ? 0 : 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: textSecondary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            TextStyle(fontSize: 13, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: RoundCountTheme.accent,
                    size: 22,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: textSecondary,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: borderColor),
      ],
    );
  }
}
