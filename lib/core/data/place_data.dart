import '../../models/place.dart';
import 'posts_data.dart';

/// Cities offered in the Places and Add place city pickers.
final List<String> kPlaceCities = [
  for (final university in kHostUniversities) university.city,
];

/// Placeholder data owned by Rümeysa (Places / Add place screens).
/// Own file on purpose, so it never conflicts with placeholder_data.dart.
/// Cities match the host universities in posts_data.dart; Lund is left
/// empty on purpose to show the empty state.
const List<Place> kPlaceholderPlaces = [
  Place(
    id: 'p1',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p1/160/160',
    name: 'Dok Coffee',
    city: 'Delft',
    category: PlaceCategory.cafe,
    rating: 4.5,
    addedBy: 'Rümeysa Ş.',
    comment: 'Great flat white, quiet in the mornings.',
  ),
  Place(
    id: 'p2',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p2/160/160',
    name: 'Kantine Oost',
    city: 'Delft',
    category: PlaceCategory.food,
    rating: 3.9,
    addedBy: 'İbrahim Halil A.',
  ),
  Place(
    id: 'p3',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p3/160/160',
    name: 'Oude Kerk',
    city: 'Delft',
    category: PlaceCategory.sights,
    rating: 5,
    addedBy: 'Rümeysa Ş.',
  ),
  Place(
    id: 'p4',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p4/160/160',
    name: 'Café Kobus Kuch',
    city: 'Delft',
    category: PlaceCategory.cafe,
    rating: 4.2,
    addedBy: 'Elif K.',
  ),
  Place(
    id: 'p5',
    name: 'Kofi',
    city: 'Delft',
    category: PlaceCategory.nightlife,
    rating: 3.5,
    addedBy: 'İbrahim Halil A.',
  ),
  Place(
    id: 'p6',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p6/160/160',
    name: 'Café Linné',
    city: 'Uppsala',
    category: PlaceCategory.cafe,
    rating: 4.5,
    addedBy: 'Mert Y.',
  ),
  Place(
    id: 'p7',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p7/160/160',
    name: 'Uppsala Cathedral',
    city: 'Uppsala',
    category: PlaceCategory.sights,
    rating: 4.8,
    addedBy: 'Mert Y.',
  ),
  Place(
    id: 'p8',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p8/160/160',
    name: 'Mercato Centrale',
    city: 'Milan',
    category: PlaceCategory.food,
    rating: 4,
    addedBy: 'Zeynep A.',
  ),
  Place(
    id: 'p9',
    imageUrl: 'https://picsum.photos/seed/erasmushub-p9/160/160',
    name: 'Café Central',
    city: 'Vienna',
    category: PlaceCategory.cafe,
    rating: 4.3,
    addedBy: 'Can D.',
  ),
];
