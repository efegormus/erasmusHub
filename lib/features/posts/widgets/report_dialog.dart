import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

const _reasons = ['Inaccurate', 'Offensive', 'Spam'];

/// "Report this post?" dialog. Returns the chosen reason, or null if cancelled.
Future<String?> showReportDialog(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _ReportDialog());

class _ReportDialog extends StatefulWidget {
  const _ReportDialog();

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String? _reason;

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(
      'Report this post?',
      textAlign: TextAlign.center,
      style: AppTextStyles.title,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Moderators will review it. Choose a reason.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            for (final reason in _reasons)
              ChoiceChip(
                label: Text(reason),
                selected: _reason == reason,
                onSelected: (_) => setState(() => _reason = reason),
              ),
          ],
        ),
      ],
    ),
    actionsAlignment: MainAxisAlignment.center,
    actionsOverflowDirection: VerticalDirection.down,
    actions: [
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: _reason == null
              ? null
              : () => Navigator.of(context).pop(_reason),
          child: const Text('Report'),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    ],
  );
}
