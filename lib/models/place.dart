/// Category of a place rated by students (wireframe page 11).
enum PlaceCategory {
  cafe('Café'),
  food('Food'),
  sights('Sights'),
  nightlife('Nightlife');

  const PlaceCategory(this.label);
  final String label;
}

/// A place in an exchange city, rated by a student.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.city,
    required this.category,
    required this.rating,
    required this.addedBy,
    this.comment = '',
  }) : assert(rating >= 0 && rating <= 5);

  final String id;
  final String name;
  final String city;
  final PlaceCategory category;

  /// Average rating between 0 and 5.
  final double rating;

  /// Display name of the student who added the place.
  final String addedBy;

  /// Optional comment. Empty when not set.
  final String comment;
}
