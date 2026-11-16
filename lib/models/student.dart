import 'user_profile.dart';

/// Another student shown on the Matches screen.
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.homeUniversity,
    required this.department,
    required this.hostUniversity,
    required this.hostCity,
    required this.hostCountry,
    required this.term,
    required this.status,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String homeUniversity;
  final String department;

  /// Exchange destination of the student.
  final String hostUniversity;
  final String hostCity;
  final String hostCountry;

  /// e.g. "Spring 2027"
  final String term;

  /// Reuses the profile status: going on exchange or returned.
  final ExchangeStatus status;

  /// Network image for the avatar; initials are shown when it fails.
  final String? avatarUrl;
}
