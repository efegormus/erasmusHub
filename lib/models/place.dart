/// Category of a place recommended by students.
enum PlaceCategory {
  food('Food & drink'),
  cafe('Café'),
  sightseeing('Sightseeing'),
  study('Study spot'),
  nightlife('Nightlife');

  const PlaceCategory(this.label);
  final String label;
}

/// A place in an exchange city, recommended by a student.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.category,
    required this.description,
    required this.rating,
    required this.addedBy,
    this.imageUrl,
  }) : assert(rating >= 0 && rating <= 5);

  final String id;
  final String name;
  final String city;
  final String country;
  final PlaceCategory category;
  final String description;

  /// Average rating between 0 and 5.
  final double rating;

  /// Display name of the student who added the place.
  final String addedBy;

  /// Network image; the card shows a local fallback when it is missing.
  final String? imageUrl;

  Place copyWith({
    String? name,
    String? city,
    String? country,
    PlaceCategory? category,
    String? description,
    double? rating,
    String? imageUrl,
  }) {
    return Place(
      id: id,
      name: name ?? this.name,
      city: city ?? this.city,
      country: country ?? this.country,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      addedBy: addedBy,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
