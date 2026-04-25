import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class EditFirearmScreen extends ConsumerStatefulWidget {
  const EditFirearmScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<EditFirearmScreen> createState() => _EditFirearmScreenState();
}

class _EditFirearmScreenState extends ConsumerState<EditFirearmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _caliberController = TextEditingController();
  final _serialController = TextEditingController();

  String _selectedClass = _firearmClasses.first;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final firearm =
          await ref.read(firearmRepositoryProvider).getById(widget.id);
      if (firearm != null && mounted) {
        setState(() {
          _brandController.text = firearm.brand;
          _modelController.text = firearm.model;
          _caliberController.text = firearm.caliber;
          _serialController.text = firearm.serialNumber ?? '';
          _selectedClass = _firearmClasses.contains(firearm.firearmClass)
              ? firearm.firearmClass
              : _firearmClasses.first;
          _loaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _caliberController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(firearmRepositoryProvider).update(
            id: widget.id,
            brand: _brandController.text.trim(),
            model: _modelController.text.trim(),
            caliber: _caliberController.text.trim(),
            firearmClass: _selectedClass,
            serialNumber: _serialController.text.trim().isEmpty
                ? null
                : _serialController.text.trim(),
          );
      if (mounted) {
        ref.invalidate(firearmByIdProvider(widget.id));
        ref.invalidate(firearmsProvider);
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Firearm',
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
              _SaveButton(saving: _saving, onPressed: _save, label: 'Save Changes'),
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
      style: const TextStyle(color: RoundCountTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: RoundCountTheme.textSecondary),
        hintStyle: const TextStyle(
            color: RoundCountTheme.textSecondary, fontSize: 14),
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedClass,
      dropdownColor: RoundCountTheme.surface,
      style: const TextStyle(color: RoundCountTheme.textPrimary),
      decoration: InputDecoration(
        labelText: 'Class',
        labelStyle: const TextStyle(color: RoundCountTheme.textSecondary),
        filled: true,
        fillColor: RoundCountTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A303A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A303A)),
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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: RoundCountTheme.textSecondary,
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
