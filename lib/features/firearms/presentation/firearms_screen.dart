import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../providers/firearm_providers.dart';

class FirearmsScreen extends ConsumerWidget {
  const FirearmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firearmsAsync = ref.watch(firearmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Armory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/firearms/add'),
        child: const Icon(Icons.add),
      ),
      body: firearmsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (firearms) => firearms.isEmpty
            ? const _EmptyState()
            : _FirearmList(firearms: firearms),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 72,
            color: RoundCountTheme.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 20),
          const Text(
            'No firearms yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to add your first firearm',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FirearmList extends StatelessWidget {
  const _FirearmList({required this.firearms});

  final List<Firearm> firearms;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: firearms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _FirearmCard(firearm: firearms[index]);
      },
    );
  }
}

class _FirearmCard extends StatelessWidget {
  const _FirearmCard({required this.firearm});

  final Firearm firearm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/firearms/${firearm.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                      '${firearm.brand} ${firearm.model}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: RoundCountTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      firearm.caliber,
                      style: const TextStyle(
                        fontSize: 13,
                        color: RoundCountTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ClassChip(label: firearm.firearmClass),
                  const SizedBox(height: 6),
                  Text(
                    '${firearm.totalRounds} rds',
                    style: const TextStyle(
                      fontSize: 12,
                      color: RoundCountTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassChip extends StatelessWidget {
  const _ClassChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: RoundCountTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(8),
        border: const Border.fromBorderSide(
          BorderSide(color: Color(0xFF2A303A)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: RoundCountTheme.textSecondary,
        ),
      ),
    );
  }
}
