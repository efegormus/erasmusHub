/// Exchange program type shown in forms and cards.
enum ExchangeProgram {
  erasmus('Erasmus+'),
  exchange('Exchange');

  const ExchangeProgram(this.label);
  final String label;
}

/// One exchange experience of a student. A user can have several.
class ExchangeExperience {
  const ExchangeExperience({
    required this.id,
    required this.hostUniversity,
    required this.city,
    required this.country,
    required this.program,
    required this.term,
    required this.department,
  });

  final String id;
  final String hostUniversity;
  final String city;
  final String country;
  final ExchangeProgram program;

  /// e.g. "Spring 2026"
  final String term;
  final String department;

  ExchangeExperience copyWith({
    String? id,
    String? hostUniversity,
    String? city,
    String? country,
    ExchangeProgram? program,
    String? term,
    String? department,
  }) {
    return ExchangeExperience(
      id: id ?? this.id,
      hostUniversity: hostUniversity ?? this.hostUniversity,
      city: city ?? this.city,
      country: country ?? this.country,
      program: program ?? this.program,
      term: term ?? this.term,
      department: department ?? this.department,
    );
  }
}
