class HistoricYear {
  int year;
  String filename;

  HistoricYear({int? year, String? filename})
      : year = year ?? 0,
        filename = filename ?? '';


  static List<HistoricYear> getLocalHistoricYears() {
    return [
      HistoricYear(year: 2022, filename: 'incendis22.json')
    ];
  }
}
