import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../providers/session_providers.dart';

class StartSessionScreen extends ConsumerStatefulWidget {
  const StartSessionScreen({super.key});

  @override
  ConsumerState<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends ConsumerState<StartSessionScreen> {
  final _notesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    try {
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      final sessionId =
          await ref.read(sessionRepositoryProvider).startSession(notes: notes);
      if (mounted) {
        context.pushReplacement('/sessions/$sessionId');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Session',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              'OPTIONAL NOTES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: RoundCountTheme.textSecondaryFor(context),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              maxLines: 3,
              style: TextStyle(color: RoundCountTheme.textPrimaryFor(context)),
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'e.g. Testing new ammo, zeroing rifle…',
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
                onPressed: _saving ? null : _start,
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
                        'Start Session',
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
