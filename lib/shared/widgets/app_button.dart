import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? Semantics(
            label: '$label, loading',
            child: const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : Text(label, textAlign: TextAlign.center);
    final style = ButtonStyle(
      side: outlined
          ? WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            )
          : null,
      minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              style: style,
              onPressed: isLoading ? null : onPressed,
              child: child,
            )
          : FilledButton(
              style: style,
              onPressed: isLoading ? null : onPressed,
              child: child,
            ),
    );
  }
}
