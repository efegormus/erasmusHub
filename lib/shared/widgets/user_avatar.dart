import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24,
  }) : assert(radius > 0);
  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    final initials = words.isEmpty
        ? '?'
        : (words.first.characters.first +
                  (words.length > 1 ? words.last.characters.first : ''))
              .toUpperCase();
    final fallback = Center(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: FittedBox(
          child: Text(initials, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
    return Semantics(
      label: name.trim().isEmpty ? 'User avatar' : '$name avatar',
      image: true,
      child: ExcludeSemantics(
        child: CircleAvatar(
          radius: radius,
          child: ClipOval(
            child: SizedBox.square(
              dimension: radius * 2,
              child: imageUrl == null || imageUrl!.trim().isEmpty
                  ? fallback
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => fallback,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
