import 'package:csv/csv_settings_autodetection.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';




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

class SatelliteData {
  final String countryId;
  final double latitude;
  final double longitude;
  final double brightTi4;
  final double scan;
  final double track;
  final DateTime acqDate;
  final int acqTime;
  final String satellite;
  final String instrument;
  final String confidence;
  final String version;
  final double brightTi5;
  final double frp;
  final String dayNight;

  SatelliteData({
    required this.countryId,
    required this.latitude,
    required this.longitude,
    required this.brightTi4,
    required this.scan,
    required this.track,
    required this.acqDate,
    required this.acqTime,
    required this.satellite,
    required this.instrument,
    required this.confidence,
    required this.version,
    required this.brightTi5,
    required this.frp,
    required this.dayNight,
  });

  factory SatelliteData.fromCsv(List<dynamic> csvRow) {
    return SatelliteData(
      countryId: csvRow[0],
      latitude: double.parse(csvRow[1].toString()),
      longitude: double.parse(csvRow[2].toString()),
      brightTi4: double.parse(csvRow[3].toString()),
      scan: double.parse(csvRow[4].toString()),
      track: double.parse(csvRow[5].toString()),
      acqDate: DateTime.parse(csvRow[6].toString()),
      acqTime: int.parse(csvRow[7].toString()),
      satellite: csvRow[8],
      instrument: csvRow[9],
      confidence: csvRow[10],
      version: csvRow[11],
      brightTi5: double.parse(csvRow[12].toString()),
      frp: double.parse(csvRow[13].toString()),
      dayNight: csvRow[14],
    );
  }

  @override
  String toString() {
    return 'SatelliteData{countryId: $countryId, latitude: $latitude, longitude: $longitude, brightTi4: $brightTi4, '
        'scan: $scan, track: $track, acqDate: $acqDate, acqTime: $acqTime, satellite: $satellite, '
        'instrument: $instrument, confidence: $confidence, version: $version, brightTi5: $brightTi5, frp: $frp, dayNight: $dayNight}';
  }
}

class NASAServiceSettings {
  static String countriesUrl = 'https://firms.modaps.eosdis.nasa.gov/api/countries?format=csv';
  static String countryLiveFireUrl = 'https://firms.modaps.eosdis.nasa.gov/api/country';

  final String format = 'csv';
  String apiKey;
  String source;
  String country;
  int dayRange;
  DateTime date;

  NASAServiceSettings({
    required this.apiKey,
    required this.source,
    required this.country,
    this.dayRange = 1,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  String getFormattedDate() {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String generateUrl() {
    return '$countryLiveFireUrl/$format/$apiKey/$source/$country/$dayRange/${getFormattedDate()}';
  }
}

class NASAService {

  final NASAServiceSettings _nasaApiCountryLiveFire = NASAServiceSettings(
      apiKey: 'fae96ccddec310c0a7538eaebc30a426',
      source: 'VIIRS_SNPP_NRT',
      country: 'ESP');

  Future<List<Country>> getCountries() async {

    var request = http.Request('GET', Uri.parse(NASAServiceSettings.countriesUrl));

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
      throw Exception('Failed to load countries: ${response.reasonPhrase}');
    }
  }

  Future<List<SatelliteData>> getLiveFire() async {

    var request = http.Request('GET', Uri.parse(_nasaApiCountryLiveFire.generateUrl()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      List<List<dynamic>> convertedRows = const CsvToListConverter(fieldDelimiter: ',', eol: '\n').convert(await response.stream.bytesToString());

      /*List<dynamic> rows = convertedRows.first;
      rows = rows.sublist(1, rows.length);
      List<Country> countries;
      var map = rows.map((e) => Country.fromCsv(e));
      countries = map.toList();*/

      List<SatelliteData> satelliteData = convertedRows.skip(1).map((row) => SatelliteData.fromCsv(row)).toList();

      return satelliteData;
    }
    else {
      print(response.reasonPhrase);
      throw Exception('Failed to load satellitedata: ${response.reasonPhrase}');
    }
  }

}
