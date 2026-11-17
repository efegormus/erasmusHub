import 'package:flutter/material.dart';

/// "Country ▾" style chip. Tapping opens a bottom sheet with the options;
/// the first option ([allLabel]) clears the filter.
class DropdownFilterChip extends StatelessWidget {
  const DropdownFilterChip({
    super.key,
    required this.label,
    required this.allLabel,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String allLabel;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  static const _clear = '';

  Future<void> _pick(BuildContext context) async {
    // Keep the keyboard from reopening on the search field after picking.
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await showModalBottomSheet<String>(
      context: context,
      // Open above the bottom navigation bar so no option is hidden.
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            _option(context, allLabel, _clear, selected: value == null),
            for (final option in options)
              _option(context, option, option, selected: value == option),
          ],
        ),
      ),
    );
    if (result == null) return; // Sheet dismissed: keep the current filter.
    onChanged(result == _clear ? null : result);
  }

  Widget _option(
    BuildContext context,
    String text,
    String result, {
    required bool selected,
  }) => ListTile(
    title: Text(text),
    selected: selected,
    trailing: selected ? const Icon(Icons.check) : null,
    onTap: () => Navigator.of(context).pop(result),
  );

  @override
  Widget build(BuildContext context) => FilterChip(
    selected: value != null,
    showCheckmark: false,
    tooltip: 'Filter by ${label.toLowerCase()}',
    onSelected: (_) => _pick(context),
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(value ?? label, overflow: TextOverflow.ellipsis)),
        const Icon(Icons.arrow_drop_down, size: 18),
      ],
    ),
  );
}
