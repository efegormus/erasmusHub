import 'user_profile.dart';

/// Another student shown on the Matches screen (wireframe page 13).
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.homeUniversity,
    required this.department,
    required this.hostUniversity,
    required this.term,
    required this.status,
    this.avatarUrl,
    this.instagram = '',
    this.linkedin = '',
    this.phone = '',
  });

  final String id;

  /// Short display name, e.g. "Rümeysa Ş.".
  final String name;
  final String homeUniversity;
  final String department;

  /// Exchange destination of the student.
  final String hostUniversity;

  /// e.g. "Fall 2024"
  final String term;

  /// Reuses the profile status: going on exchange or returned.
  final ExchangeStatus status;

  /// Network image for the avatar; initials are shown when it fails.
  final String? avatarUrl;

  /// Optional contact links. Empty when not set.
  final String instagram;
  final String linkedin;
  final String phone;

  bool get hasContacts =>
      instagram.isNotEmpty || linkedin.isNotEmpty || phone.isNotEmpty;
}
