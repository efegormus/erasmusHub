import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

/// A label above a form control, like the shared AppTextField.
class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: AppSpacing.sm - AppSpacing.xs / 2),
      child,
    ],
  );
}

/// Same look as the shared AppTextField, for dropdowns.
InputDecoration dropdownDecoration(BuildContext context, String hint) =>
    InputDecoration(
      hintText: hint,
      errorMaxLines: 3,
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
    );

/// Inline error text for custom form fields (toggles, ratings).
class FieldError extends StatelessWidget {
  const FieldError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xs),
    child: Text(
      message,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontSize: 12,
      ),
    ),
  );
}
