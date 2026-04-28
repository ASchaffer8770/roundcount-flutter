import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _feedbackEmail = 'schaffer.engineering@gmail.com';

Future<void> launchBugReportEmail(BuildContext context) async {
  final (pkg, device) = await (
    PackageInfo.fromPlatform(),
    _deviceSummary(),
  ).wait;

  final version = '${pkg.version} (${pkg.buildNumber})';
  final body = 'RoundCount Beta Bug Report\n'
      '\n'
      'Screenshot required:\n'
      'Please attach a screenshot or screen recording before sending.\n'
      '\n'
      'Device:\n'
      '$device\n'
      '\n'
      'App Version:\n'
      '$version\n'
      '\n'
      'What happened:\n'
      '\n'
      '\n'
      'Steps to reproduce:\n'
      '1.\n'
      '2.\n'
      '3.\n'
      '\n'
      'Expected result:\n'
      '\n'
      '\n'
      'Actual result:\n'
      '\n'
      '\n'
      'Notes:\n'
      '\n';

  await _launch(context, subject: 'RoundCount Beta Bug Report', body: body);
}

Future<void> launchFeatureRequestEmail(BuildContext context) async {
  final (pkg, device) = await (
    PackageInfo.fromPlatform(),
    _deviceSummary(),
  ).wait;

  final version = '${pkg.version} (${pkg.buildNumber})';
  final body = 'RoundCount Feature Request\n'
      '\n'
      'Device:\n'
      '$device\n'
      '\n'
      'App Version:\n'
      '$version\n'
      '\n'
      'Feature idea:\n'
      '\n'
      '\n'
      'Why would this be useful?\n'
      '\n'
      '\n'
      'How would you expect it to work?\n'
      '\n'
      '\n'
      'Priority:\n'
      'Low / Medium / High\n';

  await _launch(
    context,
    subject: 'RoundCount Feature Request',
    body: body,
  );
}

// ── Internals ─────────────────────────────────────────────────────────────────

Future<void> _launch(
  BuildContext context, {
  required String subject,
  required String body,
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: _feedbackEmail,
    queryParameters: {'subject': subject, 'body': body},
  );
  if (!await launchUrl(uri)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email app.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

Future<String> _deviceSummary() async {
  try {
    final plugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      final kind = info.isPhysicalDevice ? 'physical device' : 'simulator';
      return 'iOS ${info.systemVersion} — ${info.utsname.machine} (${info.name}) — $kind';
    } else if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      final kind = info.isPhysicalDevice ? 'physical device' : 'emulator';
      return 'Android ${info.version.release} (SDK ${info.version.sdkInt}) '
          '— ${info.manufacturer} ${info.model} — $kind';
    }
    return 'Unknown platform';
  } catch (_) {
    return 'Device info unavailable';
  }
}
