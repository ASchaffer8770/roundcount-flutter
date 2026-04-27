import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/feedback.dart';
import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../providers/firearm_providers.dart';
import '../providers/maintenance_providers.dart';

const _kMaintenanceTypes = [
  'Cleaning',
  'Lubrication',
  'Inspection',
  'Parts Replacement',
  'Other',
];

class AddMaintenanceEventScreen extends ConsumerStatefulWidget {
  const AddMaintenanceEventScreen({super.key, required this.firearmId});

  final String firearmId;

  @override
  ConsumerState<AddMaintenanceEventScreen> createState() =>
      _AddMaintenanceEventScreenState();
}

class _AddMaintenanceEventScreenState
    extends ConsumerState<AddMaintenanceEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roundCountController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedType;
  bool _saving = false;
  bool _prefilled = false;

  @override
  void dispose() {
    _roundCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Pre-fill round count once we have the firearm loaded.
  void _prefillIfNeeded(Firearm? firearm) {
    if (_prefilled || firearm == null) return;
    _prefilled = true;
    _roundCountController.text = '${firearm.totalRounds}';
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final roundCount = int.parse(_roundCountController.text.trim());
      await ref.read(maintenanceRepositoryProvider).addMaintenanceEvent(
            firearmId: widget.firearmId,
            type: _selectedType!,
            roundCountAtService: roundCount,
            notes: _notesController.text,
          );
      messenger.showSnackBar(successSnackBar('Maintenance logged'));
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _dropdownDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
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
        borderSide: const BorderSide(color: RoundCountTheme.accent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firearmAsync = ref.watch(firearmByIdProvider(widget.firearmId));

    firearmAsync.whenData(_prefillIfNeeded);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log Maintenance',
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
              _HelperCard(),
              const SizedBox(height: 24),
              _SectionLabel(label: 'Type'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                dropdownColor: RoundCountTheme.surfaceFor(context),
                style:
                    TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
                decoration: _dropdownDecoration(context, 'Maintenance Type *'),
                hint: Text(
                  'Select type',
                  style: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14,
                  ),
                ),
                items: _kMaintenanceTypes.map((t) {
                  return DropdownMenuItem<String>(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedType = v),
                validator: (v) => v == null ? 'Select a type' : null,
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'Round Count at Service'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roundCountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style:
                    TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
                decoration: InputDecoration(
                  labelText: 'Round Count *',
                  hintText: 'e.g. 500',
                  labelStyle: TextStyle(
                      color: RoundCountTheme.textSecondaryFor(context)),
                  hintStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 0) return 'Must be 0 or greater';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _SectionLabel(label: 'Notes (Optional)'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                maxLines: 3,
                style:
                    TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'e.g. Full field strip, replaced recoil spring',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                      color: RoundCountTheme.textSecondaryFor(context)),
                  hintStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: RoundCountTheme.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save Maintenance',
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
        ),
      ),
    );
  }
}

class _HelperCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RoundCountTheme.surfaceFor(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.fromBorderSide(
          BorderSide(color: RoundCountTheme.borderFor(context)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Maintenance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Record cleanings, lubrication, inspections, and parts changes against this firearm\'s round count.',
            style: TextStyle(
              fontSize: 13,
              color: RoundCountTheme.textSecondaryFor(context),
              height: 1.4,
            ),
          ),
        ],
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
