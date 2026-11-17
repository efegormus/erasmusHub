/// A host university that students can browse, rate and write about.
class University {
  const University({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String city;
  final String country;

  /// Banner/thumbnail photo loaded with Image.network. Null shows a fallback.
  final String? imageUrl;

  /// "Delft, Netherlands"
  String get location => '$city, $country';

  /// True when [query] appears in the name, city or country (case-insensitive).
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        city.toLowerCase().contains(q) ||
        country.toLowerCase().contains(q);
  }
}
