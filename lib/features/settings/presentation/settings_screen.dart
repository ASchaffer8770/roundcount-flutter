import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../app/theme_mode_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final textPrimary = RoundCountTheme.textPrimaryFor(context);
    final textSecondary = RoundCountTheme.textSecondaryFor(context);
    final surfaceColor = RoundCountTheme.surfaceFor(context);
    final borderColor = RoundCountTheme.borderFor(context);

    void select(ThemeMode m) =>
        ref.read(themeModeProvider.notifier).setMode(m);

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
          Text(
            'APPEARANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a display mode for indoor and outdoor range use.',
            style: TextStyle(fontSize: 14, color: textSecondary),
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
        ],
      ),
    );
  }
}

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
