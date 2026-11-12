import 'exchange_experience.dart';

/// Status of the student regarding exchange.
enum ExchangeStatus {
  planning('Going on exchange'),
  returned('Returned');

  const ExchangeStatus(this.label);
  final String label;
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.homeUniversity,
    required this.department,
    required this.status,
    this.contactLink,
    this.experiences = const [],
  });

  final String id;
  final String name;
  final String email;
  final String homeUniversity;
  final String department;
  final ExchangeStatus status;

  /// Optional contact link (e.g. Instagram or LinkedIn).
  final String? contactLink;
  final List<ExchangeExperience> experiences;

  UserProfile copyWith({
    String? name,
    String? department,
    ExchangeStatus? status,
    String? contactLink,
    List<ExchangeExperience>? experiences,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email,
      homeUniversity: homeUniversity,
      department: department ?? this.department,
      status: status ?? this.status,
      contactLink: contactLink ?? this.contactLink,
      experiences: experiences ?? this.experiences,
    );
  }
}
