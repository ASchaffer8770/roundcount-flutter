import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class RoundCountApp extends StatelessWidget {
  const RoundCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RoundCount',
      debugShowCheckedModeBanner: false,
      theme: RoundCountTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}