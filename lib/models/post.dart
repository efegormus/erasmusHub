import 'comment.dart';
import 'exchange_experience.dart';

/// The six rating categories shown on a post and in the New post form.
enum RatingCategory {
  costOfLiving('Cost of living'),
  courseDifficulty('Course difficulty'),
  professors('Professors'),
  housing('Housing'),
  safety('Safety'),
  socialLife('Social life');

  const RatingCategory(this.label);
  final String label;
}

/// An exchange experience post about one host university.
class Post {
  Post({
    required this.id,
    required this.universityId,
    required this.universityName,
    required this.title,
    required this.author,
    this.authorId,
    required this.term,
    required this.major,
    required this.program,
    required this.courses,
    required this.ratings,
    this.tip = '',
    List<Comment>? comments,
  }) : comments = comments ?? [];

  final String id;
  final String universityId;
  final String universityName;
  final String title;
  final String author;

  /// Stable account identifier used to filter the current user's posts.
  final String? authorId;

  /// e.g. "Fall 2025"
  final String term;
  final String major;
  final ExchangeProgram program;
  final List<String> courses;

  /// 1-5 stars per category, 0 means the author did not rate it.
  final Map<RatingCategory, int> ratings;
  final String tip;

  /// Mutable on purpose: the add-comment field appends to it (UI only).
  final List<Comment> comments;

  int ratingFor(RatingCategory category) => ratings[category] ?? 0;
}
