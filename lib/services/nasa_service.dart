import 'package:csv/csv_settings_autodetection.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';



class Country {
  final int id;
  final String abbreviation;
  final String name;
  final String extent;

  Country({required this.id, required this.abbreviation, required this.name, required this.extent});

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

class NASAService {

  final String _countryListUrl = 'https://firms.modaps.eosdis.nasa.gov/api/countries/?format=csv';
  final String _countryApiesUrl = 'https://firms.modaps.eosdis.nasa.gov/api/countries/?format=csv';

  Future<List<Country>> getCountryList() async {

    var request = http.Request('GET', Uri.parse(_countryListUrl));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      List<List<dynamic>> convertedRows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(await response.stream.bytesToString());

      /*List<dynamic> rows = convertedRows.first;
      rows = rows.sublist(1, rows.length);
      List<Country> countries;
      var map = rows.map((e) => Country.fromCsv(e));
      countries = map.toList();*/

      List<Country> countries = convertedRows.skip(1).map((row) => Country.fromCsv(row)).toList();

      return countries;
    }
    else {
      print(response.reasonPhrase);
      throw Exception('Failed to load country list: ${response.reasonPhrase}');
    }
  }

}
