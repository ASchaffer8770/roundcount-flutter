import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import 'theme_mode_controller.dart';

class RoundCountApp extends ConsumerWidget {
  const RoundCountApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'RoundCount',
      debugShowCheckedModeBanner: false,
      theme: RoundCountTheme.lightTheme,
      darkTheme: RoundCountTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
