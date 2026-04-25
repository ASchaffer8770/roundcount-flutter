import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../providers/ammo_providers.dart';

class AmmoDetailScreen extends ConsumerWidget {
  const AmmoDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ammoAsync = ref.watch(ammoProductByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: ammoAsync.when(
          data: (a) => Text(
            a != null ? '${a.brand} ${a.bulletType}' : 'Ammo',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          loading: () => const Text(''),
          error: (e, s) => const Text('Ammo'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push('/ammo/$id/edit'),
          ),
        ],
      ),
      body: ammoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (ammo) {
          if (ammo == null) {
            return const Center(
              child: Text(
                'Ammo not found',
                style: TextStyle(color: RoundCountTheme.textSecondary),
              ),
            );
          }
          return _AmmoDetail(ammo: ammo);
        },
      ),
    );
  }
}

class _AmmoDetail extends StatelessWidget {
  const _AmmoDetail({required this.ammo});

  final AmmoProduct ammo;

  String? get _costPerRound {
    final cpb = ammo.costPerBox;
    final qpb = ammo.quantityPerBox;
    if (cpb != null && qpb != null && qpb > 0) {
      return '\$${(cpb / qpb).toStringAsFixed(3)}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cpr = _costPerRound;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _HeroCard(ammo: ammo),
        const SizedBox(height: 16),
        _InfoSection(
          title: 'Product Details',
          items: [
            _InfoItem(label: 'Brand', value: ammo.brand),
            if (ammo.productLine != null)
              _InfoItem(label: 'Product Line', value: ammo.productLine!),
            _InfoItem(label: 'Caliber', value: ammo.caliber),
            _InfoItem(label: 'Bullet Type', value: ammo.bulletType),
            if (ammo.grain != null)
              _InfoItem(label: 'Grain Weight', value: '${ammo.grain}gr'),
            if (ammo.caseMaterial != null)
              _InfoItem(label: 'Case Material', value: ammo.caseMaterial!),
          ],
        ),
        const SizedBox(height: 16),
        _InfoSection(
          title: 'Inventory & Cost',
          items: [
            if (ammo.roundsOnHand != null)
              _InfoItem(
                  label: 'Rounds On Hand', value: '${ammo.roundsOnHand}'),
            if (ammo.quantityPerBox != null)
              _InfoItem(
                  label: 'Rounds Per Box', value: '${ammo.quantityPerBox}'),
            if (ammo.costPerBox != null)
              _InfoItem(
                  label: 'Cost Per Box',
                  value: '\$${ammo.costPerBox!.toStringAsFixed(2)}'),
            if (cpr != null)
              _InfoItem(label: 'Cost Per Round', value: cpr),
          ],
        ),
        if (ammo.notes != null) ...[
          const SizedBox(height: 16),
          _NotesCard(notes: ammo.notes!),
        ],
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.ammo});

  final AmmoProduct ammo;

  String get _caliberGrain {
    final g = ammo.grain;
    return g != null ? '${ammo.caliber} ${g}gr' : ammo.caliber;
  }

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
                Icons.inventory_2,
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
                    ammo.brand,
                    style: const TextStyle(
                      fontSize: 13,
                      color: RoundCountTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ammo.bulletType,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: RoundCountTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill(label: _caliberGrain),
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
    if (items.isEmpty) return const SizedBox.shrink();

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

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NOTES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notes,
              style: const TextStyle(
                fontSize: 14,
                color: RoundCountTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
