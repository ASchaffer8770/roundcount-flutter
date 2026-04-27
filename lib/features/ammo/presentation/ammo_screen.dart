import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../providers/ammo_providers.dart';

class AmmoScreen extends ConsumerWidget {
  const AmmoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ammoAsync = ref.watch(ammoProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ammo Inventory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ammo/add'),
        child: const Icon(Icons.add),
      ),
      body: ammoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (products) => products.isEmpty
            ? const _EmptyState()
            : _AmmoList(products: products),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
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
              Icons.inventory_2_outlined,
              size: 40,
              color: RoundCountTheme.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Add your ammo inventory',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Track rounds on hand, cost per round, and ammo burn across every training session.',
            style: TextStyle(
              fontSize: 15,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => context.push('/ammo/add'),
              style: FilledButton.styleFrom(
                backgroundColor: RoundCountTheme.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Add Ammo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmmoList extends StatelessWidget {
  const _AmmoList({required this.products});

  final List<AmmoProduct> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _AmmoCard(product: products[index]),
    );
  }
}

class _AmmoCard extends StatelessWidget {
  const _AmmoCard({required this.product});

  final AmmoProduct product;

  String get _caliberGrain {
    final g = product.grain;
    return g != null ? '${product.caliber} ${g}gr' : product.caliber;
  }

  String? get _costPerRound {
    final cpb = product.costPerBox;
    final qpb = product.quantityPerBox;
    if (cpb != null && qpb != null && qpb > 0) {
      return '\$${(cpb / qpb).toStringAsFixed(3)}/rd';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cpr = _costPerRound;
    final rounds = product.roundsOnHand;

    return Card(
      child: InkWell(
        onTap: () => context.push('/ammo/${product.id}'),
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
                  Icons.inventory_2,
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
                      '${product.brand} ${product.bulletType}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: RoundCountTheme.textPrimaryFor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _caliberGrain,
                      style: TextStyle(
                        fontSize: 13,
                        color: RoundCountTheme.textSecondaryFor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (rounds != null)
                    _Chip(
                      label: '$rounds rds',
                      color: RoundCountTheme.success,
                    ),
                  if (cpr != null) ...[
                    if (rounds != null) const SizedBox(height: 6),
                    Text(
                      cpr,
                      style: TextStyle(
                        fontSize: 12,
                        color: RoundCountTheme.textSecondaryFor(context),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.fromBorderSide(
          BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
