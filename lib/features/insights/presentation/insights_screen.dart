import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: RoundCountTheme.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.insights_outlined,
                    size: 40,
                    color: RoundCountTheme.accent,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Insights coming soon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: RoundCountTheme.textPrimaryFor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Reliability trends, ammo cost analysis, and firearm performance comparisons will appear here as you log more sessions.',
                  style: TextStyle(
                    fontSize: 15,
                    color: RoundCountTheme.textSecondaryFor(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
