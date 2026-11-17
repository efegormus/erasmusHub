import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

/// "Saved" dialog shown after a valid submit. Completes when OK is tapped.
Future<void> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
}) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    scrollable: true,
    title: Text(title, textAlign: TextAlign.center, style: AppTextStyles.title),
    content: Text(message, textAlign: TextAlign.center),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ),
    ],
  ),
);
