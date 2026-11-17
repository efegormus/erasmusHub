import '../../models/post.dart';
import '../../models/university.dart';
import 'posts_data.dart';

/// Placeholder data owned by Mehmet (Home, University detail, Add university).
/// Own file on purpose, so it never conflicts with placeholder_data.dart.
/// IDs match the host university IDs used by the post screens.
final List<University> placeholderUniversities = [
  const University(
    id: 'vienna',
    name: 'University of Vienna',
    city: 'Vienna',
    country: 'Austria',
    imageUrl: 'https://picsum.photos/seed/erasmushub-vienna/800/400',
  ),
  const University(
    id: 'polimi',
    name: 'Politecnico di Milano',
    city: 'Milan',
    country: 'Italy',
    imageUrl: 'https://picsum.photos/seed/erasmushub-milan/800/400',
  ),
  const University(
    id: 'tu-delft',
    name: 'TU Delft',
    city: 'Delft',
    country: 'Netherlands',
    imageUrl: 'https://picsum.photos/seed/erasmushub-delft/800/400',
  ),
  const University(
    id: 'uppsala',
    name: 'Uppsala University',
    city: 'Uppsala',
    country: 'Sweden',
    imageUrl: 'https://picsum.photos/seed/erasmushub-uppsala/800/400',
  ),
  const University(
    id: 'lund',
    name: 'Lund University',
    city: 'Lund',
    country: 'Sweden',
    imageUrl: 'https://picsum.photos/seed/erasmushub-lund/800/400',
  ),
  const University(
    id: 'ku-leuven',
    name: 'KU Leuven',
    city: 'Leuven',
    country: 'Belgium',
    imageUrl: 'https://picsum.photos/seed/erasmushub-leuven/800/400',
  ),
  const University(
    id: 'tum',
    name: 'Technical University of Munich',
    city: 'Munich',
    country: 'Germany',
    imageUrl: 'https://picsum.photos/seed/erasmushub-munich/800/400',
  ),
  const University(
    id: 'barcelona',
    name: 'University of Barcelona',
    city: 'Barcelona',
    country: 'Spain',
    imageUrl: 'https://picsum.photos/seed/erasmushub-barcelona/800/400',
  ),
];

/// Countries offered in the Add university form.
const List<String> kUniversityCountries = [
  'Austria',
  'Belgium',
  'Czechia',
  'Denmark',
  'Finland',
  'France',
  'Germany',
  'Hungary',
  'Ireland',
  'Italy',
  'Netherlands',
  'Norway',
  'Poland',
  'Portugal',
  'Spain',
  'Sweden',
  'Switzerland',
];

University? universityById(String id) {
  for (final university in placeholderUniversities) {
    if (university.id == id) return university;
  }
  return null;
}

/// True if a university with the same name (ignoring case/spaces) exists.
bool universityNameExists(String name) {
  final normalized = _normalize(name);
  return placeholderUniversities.any((u) => _normalize(u.name) == normalized);
}

/// Adds a new university and returns it. The ID is a unique slug of the name.
University addPlaceholderUniversity({
  required String name,
  required String city,
  required String country,
}) {
  final base = _normalize(name)
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  final slug = base.isEmpty ? 'university' : base;
  var id = slug;
  var suffix = 2;
  while (universityById(id) != null) {
    id = '$slug-${suffix++}';
  }
  final university = University(
    id: id,
    name: name.trim(),
    city: city.trim(),
    country: country,
  );
  placeholderUniversities.add(university);
  return university;
}

/// Posts about one university, newest first (same order as placeholderPosts).
List<Post> postsForUniversity(String universityId) =>
    placeholderPosts.where((p) => p.universityId == universityId).toList();

/// Average 1–5 rating of one category, or null when nobody rated it.
double? categoryAverage(String universityId, RatingCategory category) {
  final values = postsForUniversity(universityId)
      .map((p) => p.ratingFor(category))
      .where((v) => v > 0)
      .toList();
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

/// Overall average over all rated categories, or null without ratings.
double? overallAverage(String universityId) {
  final values = [
    for (final post in postsForUniversity(universityId))
      for (final category in RatingCategory.values)
        if (post.ratingFor(category) > 0) post.ratingFor(category),
  ];
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

String _normalize(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
