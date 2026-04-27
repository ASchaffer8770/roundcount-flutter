import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../providers/ammo_providers.dart';

class AddAmmoScreen extends ConsumerStatefulWidget {
  const AddAmmoScreen({super.key});

  @override
  ConsumerState<AddAmmoScreen> createState() => _AddAmmoScreenState();
}

class _AddAmmoScreenState extends ConsumerState<AddAmmoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _productLineController = TextEditingController();
  final _caliberController = TextEditingController();
  final _grainController = TextEditingController();
  final _bulletTypeController = TextEditingController();
  final _caseMaterialController = TextEditingController();
  final _quantityPerBoxController = TextEditingController();
  final _costPerBoxController = TextEditingController();
  final _roundsOnHandController = TextEditingController();
  final _notesController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _brandController.dispose();
    _productLineController.dispose();
    _caliberController.dispose();
    _grainController.dispose();
    _bulletTypeController.dispose();
    _caseMaterialController.dispose();
    _quantityPerBoxController.dispose();
    _costPerBoxController.dispose();
    _roundsOnHandController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(ammoRepositoryProvider).add(
            brand: _brandController.text.trim(),
            productLine: _productLineController.text.trim().isEmpty
                ? null
                : _productLineController.text.trim(),
            caliber: _caliberController.text.trim(),
            grain: _grainController.text.trim().isEmpty
                ? null
                : int.tryParse(_grainController.text.trim()),
            bulletType: _bulletTypeController.text.trim(),
            caseMaterial: _caseMaterialController.text.trim().isEmpty
                ? null
                : _caseMaterialController.text.trim(),
            quantityPerBox: _quantityPerBoxController.text.trim().isEmpty
                ? null
                : int.tryParse(_quantityPerBoxController.text.trim()),
            costPerBox: _costPerBoxController.text.trim().isEmpty
                ? null
                : double.tryParse(_costPerBoxController.text.trim()),
            roundsOnHand: _roundsOnHandController.text.trim().isEmpty
                ? null
                : int.tryParse(_roundsOnHandController.text.trim()),
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Ammo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const _SectionLabel(label: 'Product Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g. Federal, Hornady',
                required: true,
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _productLineController,
                label: 'Product Line',
                hint: 'e.g. Gold Medal, Critical Defense',
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _caliberController,
                label: 'Caliber',
                hint: 'e.g. 9mm, .308 Win',
                required: true,
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _bulletTypeController,
                label: 'Bullet Type',
                hint: 'e.g. FMJ, JHP, BTHP',
                required: true,
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              const _SectionLabel(label: 'Specifications'),
              const SizedBox(height: 12),
              _buildNumberField(
                controller: _grainController,
                label: 'Grain Weight',
                hint: 'e.g. 124',
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _caseMaterialController,
                label: 'Case Material',
                hint: 'e.g. Brass, Steel, Aluminum',
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              const _SectionLabel(label: 'Inventory & Cost'),
              const SizedBox(height: 12),
              _buildNumberField(
                controller: _quantityPerBoxController,
                label: 'Rounds Per Box',
                hint: 'e.g. 50',
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildDecimalField(
                controller: _costPerBoxController,
                label: 'Cost Per Box (\$)',
                hint: 'e.g. 24.99',
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildNumberField(
                controller: _roundsOnHandController,
                label: 'Rounds On Hand',
                hint: 'e.g. 500',
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              const _SectionLabel(label: 'Notes'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Optional notes about this ammo',
                maxLines: 3,
                capitalization: TextCapitalization.sentences,
                inputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              _SaveButton(saving: _saving, onPressed: _save, label: 'Save Ammo'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    int maxLines = 1,
    TextCapitalization capitalization = TextCapitalization.none,
    TextInputAction inputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: capitalization,
      textInputAction: inputAction,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
        hintStyle: TextStyle(
            color: RoundCountTheme.textSecondaryFor(context), fontSize: 14),
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputAction inputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: inputAction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
        hintStyle: TextStyle(
            color: RoundCountTheme.textSecondaryFor(context), fontSize: 14),
      ),
    );
  }

  Widget _buildDecimalField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputAction inputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: inputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
        hintStyle: TextStyle(
            color: RoundCountTheme.textSecondaryFor(context), fontSize: 14),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: RoundCountTheme.textSecondaryFor(context),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.saving,
    required this.onPressed,
    required this.label,
  });

  final bool saving;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: saving ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: RoundCountTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
