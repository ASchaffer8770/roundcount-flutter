import 'package:flutter/material.dart';

import 'theme.dart';

SnackBar successSnackBar(String message) {
  return SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    backgroundColor: RoundCountTheme.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    duration: const Duration(seconds: 2),
  );
}
