import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import 'theme_mode_controller.dart';

class RoundCountApp extends ConsumerStatefulWidget {
  const RoundCountApp({super.key, required this.onboardingComplete});

  final bool onboardingComplete;

  @override
  ConsumerState<RoundCountApp> createState() => _RoundCountAppState();
}

class _RoundCountAppState extends ConsumerState<RoundCountApp> {
  late final _router = buildRouter(
    onboardingComplete: widget.onboardingComplete,
  );

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'RoundCount',
      debugShowCheckedModeBanner: false,
      theme: RoundCountTheme.lightTheme,
      darkTheme: RoundCountTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
