import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
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
      ),
      body: firearmAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (firearm) {
          if (firearm == null) {
            return const Center(
              child: Text(
                'Firearm not found',
                style: TextStyle(color: RoundCountTheme.textSecondary),
              ),
            );
          }
          return _FirearmDetail(firearm: firearm);
        },
      ),
    );
  }
}

class _FirearmDetail extends StatelessWidget {
  const _FirearmDetail({required this.firearm});

  final Firearm firearm;

  @override
  Widget build(BuildContext context) {
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
              _InfoItem(
                  label: 'Serial Number', value: firearm.serialNumber!),
          ],
        ),
        const SizedBox(height: 16),
        _StatsCard(totalRounds: firearm.totalRounds),
      ],
    );
  }
}

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
                    style: const TextStyle(
                      fontSize: 13,
                      color: RoundCountTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    firearm.model,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: RoundCountTheme.textPrimary,
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
        color: RoundCountTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(20),
        border: const Border.fromBorderSide(
          BorderSide(color: Color(0xFF2A303A)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: RoundCountTheme.textSecondary,
        ),
      ),
    );
  }
}

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
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondary,
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
            style: const TextStyle(
              fontSize: 14,
              color: RoundCountTheme.textSecondary,
            ),
          ),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimary,
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.totalRounds});

  final int totalRounds;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STATS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: RoundCountTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: RoundCountTheme.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalRounds',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: RoundCountTheme.textPrimary,
                      ),
                    ),
                    const Text(
                      'Total Rounds',
                      style: TextStyle(
                        fontSize: 13,
                        color: RoundCountTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
