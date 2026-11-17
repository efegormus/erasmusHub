import 'package:flutter/foundation.dart';

import '../../core/data/place_data.dart';
import '../../models/place.dart';

/// In-memory list of places shared by the Places and Add place screens.
/// Placeholder until Firebase arrives in Step 3.
class PlacesStore extends ValueNotifier<List<Place>> {
  PlacesStore() : super(List.of(kPlaceholderPlaces));

  void add(Place place) => value = [place, ...value];

  /// Returns the index the place had, so it can be restored with [insert].
  int remove(Place place) {
    final index = value.indexWhere((p) => p.id == place.id);
    if (index >= 0) value = [...value]..removeAt(index);
    return index;
  }

  void insert(int index, Place place) =>
      value = [...value]..insert(index.clamp(0, value.length), place);

  /// Restores the placeholder data (used by tests).
  void reset() => value = List.of(kPlaceholderPlaces);
}

final placesStore = PlacesStore();
