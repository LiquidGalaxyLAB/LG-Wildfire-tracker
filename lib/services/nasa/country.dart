class Country {
  int id;
  String abbreviation;
  String name;
  String extent;

  Country({int? id, String? abbreviation, String? name, String? extent})
      : id = id ?? 0,
        abbreviation = abbreviation ?? '',
        name = name ?? '',
        extent = extent ?? '';

  factory Country.fromCsv(List<dynamic> csvRow) {
    return Country(
      id: csvRow[0],
      abbreviation: csvRow[1],
      name: csvRow[2],
      extent: csvRow[3],
    );
  }

  @override
  String toString() {
    return 'Country{id: $id, abbreviation: $abbreviation, name: $name, extent: $extent}';
  }
}