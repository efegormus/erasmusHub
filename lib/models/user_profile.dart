import 'exchange_experience.dart';

// Re-exported so screens that only need the status enum can import this file.
export 'exchange_experience.dart' show ExchangeStatus;

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.homeUniversity,
    required this.major,
    required this.status,
    this.minor = '',
    this.instagram = '',
    this.linkedin = '',
    this.phone = '',
    this.experiences = const [],
  });

  final String id;
  final String name;
  final String email;
  final String homeUniversity;
  final String major;

  /// Optional double major or minor. Empty when not set.
  final String minor;
  final ExchangeStatus status;

  /// Optional contact links. Empty when not set.
  final String instagram;
  final String linkedin;
  final String phone;
  final List<ExchangeExperience> experiences;

  UserProfile copyWith({
    String? name,
    String? major,
    String? minor,
    ExchangeStatus? status,
    String? instagram,
    String? linkedin,
    String? phone,
    List<ExchangeExperience>? experiences,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email,
      homeUniversity: homeUniversity,
      major: major ?? this.major,
      minor: minor ?? this.minor,
      status: status ?? this.status,
      instagram: instagram ?? this.instagram,
      linkedin: linkedin ?? this.linkedin,
      phone: phone ?? this.phone,
      experiences: experiences ?? this.experiences,
    );
  }
}
