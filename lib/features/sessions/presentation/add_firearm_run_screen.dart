import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/feedback.dart';
import '../../../app/theme.dart';
import '../../../data/db/app_database.dart';
import '../../ammo/providers/ammo_providers.dart';
import '../../firearms/providers/firearm_providers.dart';
import '../providers/session_providers.dart';

class AddFirearmRunScreen extends ConsumerStatefulWidget {
  const AddFirearmRunScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<AddFirearmRunScreen> createState() =>
      _AddFirearmRunScreenState();
}

class _AddFirearmRunScreenState extends ConsumerState<AddFirearmRunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roundsController = TextEditingController();
  final _malfunctionsController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedFirearmId;
  String? _selectedAmmoProductId;
  bool _saving = false;

  @override
  void dispose() {
    _roundsController.dispose();
    _malfunctionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFirearmId == null) return;

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final roundsFired = int.parse(_roundsController.text.trim());
      final malfunctionCount =
          int.tryParse(_malfunctionsController.text.trim()) ?? 0;
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      await ref.read(sessionRepositoryProvider).addFirearmRun(
            sessionId: widget.sessionId,
            firearmId: _selectedFirearmId!,
            ammoProductId: _selectedAmmoProductId,
            roundsFired: roundsFired,
            malfunctionCount: malfunctionCount,
            notes: notes,
          );
      messenger.showSnackBar(successSnackBar('Run logged'));
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firearmsAsync = ref.watch(firearmsProvider);
    final ammoAsync = ref.watch(ammoProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Run',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: firearmsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: const TextStyle(color: RoundCountTheme.danger)),
        ),
        data: (firearms) {
          if (firearms.isEmpty) {
            return const _NoFirearmsMessage();
          }
          return _RunForm(
            formKey: _formKey,
            firearms: firearms,
            ammoAsync: ammoAsync,
            selectedFirearmId: _selectedFirearmId,
            selectedAmmoProductId: _selectedAmmoProductId,
            roundsController: _roundsController,
            malfunctionsController: _malfunctionsController,
            notesController: _notesController,
            saving: _saving,
            onFirearmChanged: (v) => setState(() => _selectedFirearmId = v),
            onAmmoChanged: (v) => setState(() => _selectedAmmoProductId = v),
            onSave: _save,
          );
        },
      ),
    );
  }
}

class _NoFirearmsMessage extends StatelessWidget {
  const _NoFirearmsMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 64,
              color: RoundCountTheme.textSecondaryFor(context)
                  .withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'No firearms yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: RoundCountTheme.textPrimaryFor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a firearm in the Armory tab before logging a run.',
              style: TextStyle(
                fontSize: 15,
                color: RoundCountTheme.textSecondaryFor(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RunForm extends StatelessWidget {
  const _RunForm({
    required this.formKey,
    required this.firearms,
    required this.ammoAsync,
    required this.selectedFirearmId,
    required this.selectedAmmoProductId,
    required this.roundsController,
    required this.malfunctionsController,
    required this.notesController,
    required this.saving,
    required this.onFirearmChanged,
    required this.onAmmoChanged,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final List<Firearm> firearms;
  final AsyncValue<List<AmmoProduct>> ammoAsync;
  final String? selectedFirearmId;
  final String? selectedAmmoProductId;
  final TextEditingController roundsController;
  final TextEditingController malfunctionsController;
  final TextEditingController notesController;
  final bool saving;
  final ValueChanged<String?> onFirearmChanged;
  final ValueChanged<String?> onAmmoChanged;
  final VoidCallback onSave;

  InputDecoration _dropdownDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          TextStyle(color: RoundCountTheme.textSecondaryFor(context)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _RunHelperCard(),
            const SizedBox(height: 24),
            _SectionLabel(label: 'Firearm'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedFirearmId,
              dropdownColor: RoundCountTheme.surfaceFor(context),
              style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
              decoration: _dropdownDecoration(context, 'Firearm *'),
              hint: Text(
                'Select firearm',
                style: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14),
              ),
              items: firearms.map((f) {
                return DropdownMenuItem<String>(
                  value: f.id,
                  child: Text('${f.brand} ${f.model}'),
                );
              }).toList(),
              onChanged: onFirearmChanged,
              validator: (v) => v == null ? 'Select a firearm' : null,
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: 'Ammo (Optional)'),
            const SizedBox(height: 12),
            ammoAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => const SizedBox.shrink(),
              data: (ammoList) => DropdownButtonFormField<String?>(
                initialValue: selectedAmmoProductId,
                dropdownColor: RoundCountTheme.surfaceFor(context),
                style:
                    TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
                decoration: _dropdownDecoration(context, 'Ammo'),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      ammoList.isEmpty ? 'No ammo products yet' : 'None',
                      style: TextStyle(
                          color: RoundCountTheme.textSecondaryFor(context)),
                    ),
                  ),
                  ...ammoList.map((a) {
                    final label = a.grain != null
                        ? '${a.brand} ${a.caliber} ${a.grain}gr'
                        : '${a.brand} ${a.caliber}';
                    return DropdownMenuItem<String?>(
                      value: a.id,
                      child: Text(label),
                    );
                  }),
                ],
                onChanged: onAmmoChanged,
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: 'Round Count'),
            const SizedBox(height: 12),
            TextFormField(
              controller: roundsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
              decoration: InputDecoration(
                labelText: 'Rounds Fired *',
                hintText: 'e.g. 50',
                labelStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context)),
                hintStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: malfunctionsController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
              decoration: InputDecoration(
                labelText: 'Malfunctions',
                hintText: '0',
                labelStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context)),
                hintStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final n = int.tryParse(v.trim());
                if (n == null || n < 0) return 'Must be 0 or greater';
                return null;
              },
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: 'Notes (Optional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: notesController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              maxLines: 3,
              style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'e.g. Grouping was tight at 25 yards…',
                alignLabelWithHint: true,
                labelStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context)),
                hintStyle: TextStyle(
                    color: RoundCountTheme.textSecondaryFor(context),
                    fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: saving ? null : onSave,
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
                    : const Text(
                        'Add Run',
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
    );
  }
}

class _RunHelperCard extends StatelessWidget {
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
            'Log a firearm run',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RoundCountTheme.textPrimaryFor(context),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'A firearm run captures one firearm and ammo combination inside this session — rounds fired, ammo used, malfunctions, and notes.',
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
