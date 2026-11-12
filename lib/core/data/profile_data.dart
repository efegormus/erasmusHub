import '../../models/exchange_experience.dart';
import '../../models/user_profile.dart';

/// Placeholder data owned by Onur (profile / sign-up screens).
/// Own file on purpose, so it never conflicts with placeholder_data.dart.
const List<ExchangeExperience> kPlaceholderExperiences = [
  ExchangeExperience(
    id: 'exp1',
    hostUniversity: 'Uppsala University',
    city: 'Uppsala',
    country: 'Sweden',
    program: ExchangeProgram.erasmus,
    term: 'Spring 2026',
    department: 'Computer Science',
  ),
  ExchangeExperience(
    id: 'exp2',
    hostUniversity: 'TU Delft',
    city: 'Delft',
    country: 'Netherlands',
    program: ExchangeProgram.exchange,
    term: 'Fall 2025',
    department: 'Computer Science',
  ),
];

const UserProfile kCurrentUser = UserProfile(
  id: 'u1',
  name: 'Utku Batmaz',
  email: 'utku.batmaz@sabanciuniv.edu',
  homeUniversity: 'Sabancı University',
  department: 'Computer Science',
  status: ExchangeStatus.returned,
  contactLink: 'https://www.linkedin.com/in/example',
  experiences: kPlaceholderExperiences,
);
