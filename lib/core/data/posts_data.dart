import '../../models/comment.dart';
import '../../models/exchange_experience.dart';
import '../../models/post.dart';

/// A host university choice for the post and exchange forms.
/// Temporary list until the shared University model is on `main`.
class HostUniversity {
  const HostUniversity({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
  });

  final String id;
  final String name;
  final String city;
  final String country;
}

const List<HostUniversity> kHostUniversities = [
  HostUniversity(
    id: 'tu-delft',
    name: 'TU Delft',
    city: 'Delft',
    country: 'Netherlands',
  ),
  HostUniversity(
    id: 'uppsala',
    name: 'Uppsala University',
    city: 'Uppsala',
    country: 'Sweden',
  ),
  HostUniversity(
    id: 'polimi',
    name: 'Politecnico di Milano',
    city: 'Milan',
    country: 'Italy',
  ),
  HostUniversity(
    id: 'vienna',
    name: 'University of Vienna',
    city: 'Vienna',
    country: 'Austria',
  ),
  HostUniversity(
    id: 'lund',
    name: 'Lund University',
    city: 'Lund',
    country: 'Sweden',
  ),
];

const List<String> kTerms = [
  'Spring 2027',
  'Fall 2026',
  'Spring 2026',
  'Fall 2025',
  'Spring 2025',
  'Fall 2024',
  'Spring 2024',
];

HostUniversity? hostUniversityById(String? id) {
  for (final university in kHostUniversities) {
    if (university.id == id) return university;
  }
  return null;
}

/// Shared mutable list: New post inserts here, the detail screen reads it.
final List<Post> placeholderPosts = [
  Post(
    id: 'post1',
    universityId: 'tu-delft',
    universityName: 'TU Delft',
    title: 'Great courses, hard housing',
    author: 'Onur',
    term: 'Fall 2025',
    major: 'Computer Science',
    program: ExchangeProgram.erasmus,
    courses: ['Algorithms', 'Databases'],
    ratings: {
      RatingCategory.costOfLiving: 3,
      RatingCategory.courseDifficulty: 4,
      RatingCategory.professors: 5,
      RatingCategory.housing: 2,
      RatingCategory.safety: 5,
      RatingCategory.socialLife: 4,
    },
    tip: 'Apply for housing before you get accepted.',
    comments: [
      const Comment(
        id: 'c1',
        author: 'İbrahim',
        text: 'Which dorm did you pick?',
      ),
      const Comment(
        id: 'c2',
        author: 'Onur',
        text: 'Try the student housing office early.',
      ),
    ],
  ),
  Post(
    id: 'post2',
    universityId: 'tu-delft',
    universityName: 'TU Delft',
    title: 'Cheap by bike, pricey by rent',
    author: 'Efe',
    term: 'Spring 2025',
    major: 'Computer Science',
    program: ExchangeProgram.exchange,
    courses: ['Software Engineering'],
    ratings: {
      RatingCategory.costOfLiving: 3,
      RatingCategory.courseDifficulty: 3,
      RatingCategory.professors: 4,
      RatingCategory.housing: 3,
      RatingCategory.safety: 5,
      RatingCategory.socialLife: 5,
    },
    tip: 'Buy a second-hand bike in the first week.',
    comments: [
      const Comment(
        id: 'c3',
        author: 'Mehmet',
        text: 'How much was your rent?',
      ),
      const Comment(id: 'c4', author: 'Efe', text: 'Around 600 euros.'),
      const Comment(
        id: 'c5',
        author: 'Rümeysa',
        text: 'Was the bike easy to find?',
      ),
      const Comment(
        id: 'c6',
        author: 'Efe',
        text: 'Yes, check the student groups.',
      ),
      const Comment(id: 'c7', author: 'İbrahim', text: 'Thanks for the tip!'),
    ],
  ),
  Post(
    id: 'post3',
    universityId: 'uppsala',
    universityName: 'Uppsala University',
    title: 'Student nations are the best part',
    author: 'Rümeysa',
    term: 'Spring 2025',
    major: 'Computer Science',
    program: ExchangeProgram.erasmus,
    courses: ['Machine Learning', 'Swedish for Beginners'],
    ratings: {
      RatingCategory.costOfLiving: 2,
      RatingCategory.courseDifficulty: 3,
      RatingCategory.professors: 4,
      RatingCategory.housing: 3,
      RatingCategory.safety: 5,
      RatingCategory.socialLife: 5,
    },
    tip: 'Join a student nation in the first week.',
  ),
  Post(
    id: 'post4',
    universityId: 'polimi',
    universityName: 'Politecnico di Milano',
    title: 'Heavy workload, great city',
    author: 'Mehmet',
    term: 'Fall 2024',
    major: 'Computer Science',
    program: ExchangeProgram.erasmus,
    courses: ['Computer Graphics', 'Operating Systems'],
    ratings: {
      RatingCategory.costOfLiving: 2,
      RatingCategory.courseDifficulty: 5,
      RatingCategory.professors: 3,
      RatingCategory.housing: 2,
      RatingCategory.safety: 4,
      RatingCategory.socialLife: 4,
    },
    tip: 'Start looking for a room months before you arrive.',
  ),
];

/// 'preview' is the link used by the University detail placeholder.
Post? postById(String id) {
  for (final post in placeholderPosts) {
    if (post.id == id) return post;
  }
  return id == 'preview' && placeholderPosts.isNotEmpty
      ? placeholderPosts.first
      : null;
}
