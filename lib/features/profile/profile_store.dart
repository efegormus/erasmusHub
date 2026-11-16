import 'package:flutter/foundation.dart';

import '../../core/data/profile_data.dart';
import '../../models/exchange_experience.dart';
import '../../models/user_profile.dart';

/// In-memory profile shared by the profile screens (no backend yet).
/// Other screens (e.g. Add exchange) can call [addExperience].
class ProfileStore extends ValueNotifier<UserProfile> {
  ProfileStore(super.value);

  void update(UserProfile profile) => value = profile;

  void addExperience(ExchangeExperience experience) {
    value = value.copyWith(experiences: [...value.experiences, experience]);
  }

  void removeExperience(String id) {
    value = value.copyWith(
      experiences: value.experiences.where((e) => e.id != id).toList(),
    );
  }

  void restoreExperience(int index, ExchangeExperience experience) {
    final list = [...value.experiences];
    list.insert(index.clamp(0, list.length), experience);
    value = value.copyWith(experiences: list);
  }
}

final profileStore = ProfileStore(kCurrentUser);
