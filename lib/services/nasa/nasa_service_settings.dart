import 'package:intl/intl.dart';

class NASAServiceSettings {
  static String nasaApiKey = "fae96ccddec310c0a7538eaebc30a426";
  static List<String> satellites = [
    'VIIRS_NOAA21_NRT',
    'VIIRS_SNPP_SP',
    'LANDSAT_NRT',
    'MODIS_NRT',
    'MODIS_SP',
    'VIIRS_NOAA20_NRT',
    'VIIRS_SNPP_NRT',
  ];
  static String countriesUrl =
      'https://firms.modaps.eosdis.nasa.gov/api/countries?format=csv';
  static String countryLiveFireUrl =
      'https://firms.modaps.eosdis.nasa.gov/api/country';

  final String format = 'csv';
  String apiKey;
  String source;
  String country;
  int dayRange;
  DateTime date;

  NASAServiceSettings({
    required this.apiKey,
    this.source = 'VIIRS_NOAA20_NRT',
    this.country = 'ESP',
    this.dayRange = 1,
    DateTime? date,
  }) : date = date ?? DateTime.now().subtract(const Duration(days: 1));

  String getFormattedDate() {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String generateUrl({int satelliteIndex = 0}) {
    if (satelliteIndex >= satellites.length || satelliteIndex < 0)
      satelliteIndex = 0;
    return '$countryLiveFireUrl/$format/$apiKey/${satellites[satelliteIndex]}/$country/$dayRange/${getFormattedDate()}';
  }
}