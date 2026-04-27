import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/feedback.dart';
import '../../../app/theme.dart';
import '../providers/firearm_providers.dart';

const _firearmClasses = [
  'Pistol',
  'Revolver',
  'Rifle',
  'Shotgun',
  'PCC',
  'Other',
];

class AddFirearmScreen extends ConsumerStatefulWidget {
  const AddFirearmScreen({super.key});

  @override
  ConsumerState<AddFirearmScreen> createState() => _AddFirearmScreenState();
}

class _AddFirearmScreenState extends ConsumerState<AddFirearmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _caliberController = TextEditingController();
  final _serialController = TextEditingController();

  String _selectedClass = _firearmClasses.first;
  bool _saving = false;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _caliberController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(firearmRepositoryProvider).add(
            brand: _brandController.text.trim(),
            model: _modelController.text.trim(),
            caliber: _caliberController.text.trim(),
            firearmClass: _selectedClass,
            serialNumber: _serialController.text.trim().isEmpty
                ? null
                : _serialController.text.trim(),
          );
      messenger.showSnackBar(successSnackBar('Firearm added'));
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
          'Add Firearm',
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
              const _SectionLabel(label: 'Firearm Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _brandController,
                label: 'Brand',
                hint: 'e.g. Glock, Smith & Wesson',
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _modelController,
                label: 'Model',
                hint: 'e.g. 19, M&P 9',
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _caliberController,
                label: 'Caliber',
                hint: 'e.g. 9mm, .45 ACP',
                capitalization: TextCapitalization.words,
                inputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _buildClassDropdown(),
              const SizedBox(height: 24),
              const _SectionLabel(label: 'Optional'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _serialController,
                label: 'Serial Number',
                hint: 'Optional',
                required: false,
                capitalization: TextCapitalization.characters,
                inputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              _SaveButton(saving: _saving, onPressed: _save, label: 'Save Firearm'),
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
    bool required = true,
    TextCapitalization capitalization = TextCapitalization.none,
    TextInputAction inputAction = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
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

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedClass,
      dropdownColor: RoundCountTheme.surfaceFor(context),
      style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
      decoration: InputDecoration(
        labelText: 'Class',
        labelStyle: TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
        filled: true,
        fillColor: RoundCountTheme.surfaceFor(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: RoundCountTheme.accent, width: 1.5),
        ),
      ),
      items: _firearmClasses
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _selectedClass = v);
      },
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
