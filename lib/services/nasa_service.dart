import 'package:csv/csv_settings_autodetection.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:wildfiretracker/entities/kml/line_entity.dart';
import 'package:wildfiretracker/entities/kml/placemark_entity.dart';
import 'package:wildfiretracker/entities/kml/point_entity.dart';




class Country {
  int id;
  String abbreviation;
  String name;
  String extent;

  Country({
    int? id,
    String? abbreviation,
    String? name,
    String? extent}) :
        id = id ?? 0,
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

  /*@override
  String toString() {
    return '$name';
  }*/
  @override
  String toString() {
    return 'Country{id: $id, abbreviation: $abbreviation, name: $name, extent: $extent}';
  }

}

class SatelliteData {
  String id = '';
  String countryId;
  double latitude;
  double longitude;
  double brightTi4;
  double scan;
  double track;
  DateTime? acqDate;
  int acqTime;
  String satellite;
  String instrument;
  String confidence;
  String version;
  double brightTi5;
  double frp;
  String dayNight;

  /*SatelliteData({
    this.countryId = '',
    this.latitude = 0,
    this.longitude = 0,
    this.brightTi4 = 0,
    this.scan = 0,
    this.track = 0,
    this.acqDate,
    this.acqTime = 0,
    this.satellite = '',
    this.instrument = '',
    this.confidence = '',
    this.version = '',
    this.brightTi5 = 0,
    this.frp = 0,
    this.dayNight = ''
  }){
    id = '$latitude-$longitude';
  }*/

  SatelliteData({
    String? countryId,
    double? latitude,
    double? longitude,
    double? brightTi4,
    double? scan,
    double? track,
    DateTime? acqDate,
    int? acqTime,
    String? satellite,
    String? instrument,
    String? confidence,
    String? version,
    double? brightTi5,
    double? frp,
    String? dayNight,
  })   : countryId = countryId ?? '',
        latitude = latitude ?? 0,
        longitude = longitude ?? 0,
        brightTi4 = brightTi4 ?? 0,
        scan = scan ?? 0,
        track = track ?? 0,
        acqDate = acqDate,
        acqTime = acqTime ?? 0,
        satellite = satellite ?? '',
        instrument = instrument ?? '',
        confidence = confidence ?? '',
        version = version ?? '',
        brightTi5 = brightTi5 ?? 0,
        frp = frp ?? 0,
        dayNight = dayNight ?? '',
        id = '$latitude-$longitude';

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

  PlacemarkEntity toPlacemarkEntity(){
    return PlacemarkEntity(
        id: '$latitude-$longitude',
        name: '',
        point: PointEntity(altitude: 600, lat: latitude, lng: longitude),
        line: LineEntity(id: '', coordinates: [])
    );
  }

  /*

    /// Builds and returns a satellite `Placemark` entity according to the given
  /// [station] and other params.
  PlacemarkEntity buildPlacemark(
    GroundStationEntity station,
    bool balloon, {
    Map<String, dynamic>? extraData,
    bool updatePosition = true,
  }) {
    final lookAt = LookAtEntity(
      lng: station.lng,
      lat: station.lat,
      range: '1500',
      tilt: '60',
      heading: '0',
    );

    final point = PointEntity(
      lat: lookAt.lat,
      lng: lookAt.lng,
      altitude: lookAt.altitude,
    );

    return PlacemarkEntity(
      id: station.id.toString(),
      name: '${station.name} (${station.getStatusLabel().toUpperCase()})',
      lookAt: updatePosition ? lookAt : null,
      point: point,
      description: '',
      viewOrbit: false,
      scale: 2.0,
      balloonContent:
          extraData != null && balloon ? station.balloonContent(extraData) : '',
      icon: 'station.png',
      line: LineEntity(id: station.id.toString(), coordinates: []),
    );
  }

  */

  @override
  String toString() {
    return 'SatelliteData{countryId: $countryId, latitude: $latitude, longitude: $longitude, brightTi4: $brightTi4, '
        'scan: $scan, track: $track, acqDate: $acqDate, acqTime: $acqTime, satellite: $satellite, '
        'instrument: $instrument, confidence: $confidence, version: $version, brightTi5: $brightTi5, frp: $frp, dayNight: $dayNight}';
  }

  getDateTime() {
    return DateFormat('dd/MM/yy').format(acqDate!);
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
      country: 'ESP',
      date: DateTime(2024,1,21)
      //country: 'ESP'
  );

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

  Future<List<SatelliteData>> getLiveFire({String? countryAbbreviation}) async {

    if (countryAbbreviation != null && countryAbbreviation.isNotEmpty) {
      _nasaApiCountryLiveFire.country = countryAbbreviation;
    }

    var request = http.Request('GET', Uri.parse(_nasaApiCountryLiveFire.generateUrl()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<List<dynamic>> convertedRows = const CsvToListConverter(fieldDelimiter: ',', eol: '\n').convert(await response.stream.bytesToString());
      List<SatelliteData> satelliteData = convertedRows.skip(1).map((row) => SatelliteData.fromCsv(row)).toList();

      return satelliteData;
    }
    else {
      print(response.reasonPhrase);
      throw Exception('Failed to load satellite data: ${response.reasonPhrase}');
    }
  }

}
