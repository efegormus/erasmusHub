import '../../models/student.dart';
import '../../models/user_profile.dart';

/// Placeholder data owned by Rümeysa (Matches screen).
/// Own file on purpose, so it never conflicts with placeholder_data.dart.
/// Host universities match kHostUniversities in posts_data.dart; Lund has
/// no returned student on purpose to show the empty state.
const List<Student> kPlaceholderStudents = [
  Student(
    id: 's1',
    name: 'Rümeysa Ş.',
    homeUniversity: 'Sabancı',
    department: 'Computer Science',
    hostUniversity: 'TU Delft',
    term: 'Fall 2024',
    status: ExchangeStatus.returned,
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    instagram: '@rumeysa.exchange',
    linkedin: 'linkedin.com/in/rumeysa',
    phone: '+90 555 000 00 01',
  ),
  Student(
    id: 's2',
    name: 'İbrahim Halil A.',
    homeUniversity: 'Sabancı',
    department: 'Computer Science',
    hostUniversity: 'TU Delft',
    term: 'Spring 2025',
    status: ExchangeStatus.returned,
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    instagram: '@ibrahim.delft',
    linkedin: 'linkedin.com/in/ibrahim',
  ),
  Student(
    id: 's3',
    name: 'Elif K.',
    homeUniversity: 'Boğaziçi',
    department: 'Computer Engineering',
    hostUniversity: 'TU Delft',
    term: 'Fall 2025',
    status: ExchangeStatus.returned,
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
    linkedin: 'linkedin.com/in/elif',
  ),
  Student(
    id: 's4',
    name: 'Mert Y.',
    homeUniversity: 'Sabancı',
    department: 'Computer Science',
    hostUniversity: 'Uppsala University',
    term: 'Spring 2025',
    status: ExchangeStatus.returned,
    instagram: '@mert.uppsala',
  ),
  Student(
    id: 's5',
    name: 'Can D.',
    homeUniversity: 'Sabancı',
    department: 'Computer Science',
    hostUniversity: 'Uppsala University',
    term: 'Spring 2027',
    status: ExchangeStatus.planning,
  ),
  Student(
    id: 's6',
    name: 'Zeynep A.',
    homeUniversity: 'Koç',
    department: 'Economics',
    hostUniversity: 'Politecnico di Milano',
    term: 'Spring 2026',
    status: ExchangeStatus.returned,
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    instagram: '@zeynep.milano',
    phone: '+90 555 000 00 06',
  ),
];
