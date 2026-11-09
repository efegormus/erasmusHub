abstract final class Validators {
  static String? required(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required.'
        : null;
  }

  /// Suitable for TextFormField.validator; spaces count toward password length.
  static String? Function(String?) minLength(int minimum) {
    if (minimum < 0) {
      throw ArgumentError.value(minimum, 'minimum', 'Must not be negative.');
    }
    return (value) => (value?.runes.length ?? 0) < minimum
        ? 'Enter at least $minimum characters.'
        : null;
  }

  /// Academic suffix heuristic, not proof of enrollment or email ownership.
  static String? universityEmail(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    final parts = value!.trim().toLowerCase().split('@');
    if (parts.length != 2 ||
        !RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~.-]+$").hasMatch(parts.first) ||
        parts.first.startsWith('.') ||
        parts.first.endsWith('.') ||
        parts.first.contains('..')) {
      return 'Enter a valid university email address.';
    }
    final labels = parts.last.split('.');
    final validLabel = RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$');
    if (labels.length < 2 || !labels.every(validLabel.hasMatch)) {
      return 'Enter a valid university email address.';
    }
    final isAcademic =
        labels.last == 'edu' ||
        (labels.length >= 3 &&
            RegExp(r'^[a-z]{2}$').hasMatch(labels.last) &&
            {'edu', 'ac'}.contains(labels[labels.length - 2]));
    return isAcademic ? null : 'Use your university email address.';
  }
}
