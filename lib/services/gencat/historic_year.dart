class HistoricYear {
  int year;
  String filename;

  HistoricYear({int? year, String? filename})
      : year = year ?? 0,
        filename = filename ?? '';


  static List<HistoricYear> getLocalHistoricYears() {
    return [
      HistoricYear(year: 2022, filename: 'incendis22.json'),
      HistoricYear(year: 2021, filename: 'incendis21.json'),
      HistoricYear(year: 2001, filename: 'incendis01.json'),
      HistoricYear(year: 2002, filename: 'incendis02.json'),
      HistoricYear(year: 1998, filename: 'incendis98.json'),
      HistoricYear(year: 1994, filename: 'incendis94.json'),
      HistoricYear(year: 1992, filename: 'incendis92.json'),
      HistoricYear(year: 1986, filename: 'incendis86.json'),
    ];
  }
}
