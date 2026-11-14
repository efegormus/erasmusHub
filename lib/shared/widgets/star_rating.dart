import 'package:flutter/material.dart';

/// Controlled 1–5 star input, or fractional read-only rating when onChanged is null.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 24,
  }) : assert(value >= 0 && value <= 5),
       assert(size > 0);
  final double value;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final stars = List.generate(5, (index) {
      final icon = Icon(
        value >= index + 1
            ? Icons.star
            : value > index
            ? Icons.star_half
            : Icons.star_border,
        size: size,
        color: Theme.of(context).colorScheme.primary,
      );
      return onChanged == null
          ? icon
          : Semantics(
              selected: value == index + 1,
              child: IconButton(
                tooltip: 'Rate ${index + 1} of 5 stars',
                onPressed: () => onChanged!(index + 1),
                icon: icon,
              ),
            );
    });
    return onChanged == null
        ? Semantics(
            label: '$value out of 5 stars',
            child: ExcludeSemantics(child: Wrap(children: stars)),
          )
        : Wrap(children: stars);
  }
}
