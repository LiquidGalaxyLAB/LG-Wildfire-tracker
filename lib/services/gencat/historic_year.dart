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
      HistoricYear(year: 2003, filename: 'incendis03.json'),
      HistoricYear(year: 2002, filename: 'incendis02.json'),
      HistoricYear(year: 2001, filename: 'incendis01.json'),
      HistoricYear(year: 2000, filename: 'incendis00.json'),
      HistoricYear(year: 1999, filename: 'incendis99.json'),
      HistoricYear(year: 1998, filename: 'incendis98.json'),
      HistoricYear(year: 1997, filename: 'incendis97.json'),
      HistoricYear(year: 1996, filename: 'incendis96.json'),
      HistoricYear(year: 1995, filename: 'incendis95.json'),
      HistoricYear(year: 1994, filename: 'incendis94.json'),
      HistoricYear(year: 1993, filename: 'incendis93.json'),
      HistoricYear(year: 1992, filename: 'incendis92.json'),
      HistoricYear(year: 1991, filename: 'incendis91.json'),
      HistoricYear(year: 1990, filename: 'incendis90.json'),
      HistoricYear(year: 1989, filename: 'incendis89.json'),
      HistoricYear(year: 1988, filename: 'incendis88.json'),
      HistoricYear(year: 1987, filename: 'incendis87.json'),
      HistoricYear(year: 1986, filename: 'incendis86.json')
    ];
  }
}
