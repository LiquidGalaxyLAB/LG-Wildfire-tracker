import 'package:csv/csv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:wildfiretracker/services/local_storage_service.dart';
import 'package:wildfiretracker/utils/storage_keys.dart';

import 'country.dart';
import 'nasa_service_settings.dart';
import 'satellite_data.dart';



class NASAService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  NASAServiceSettings nasaApiCountryLiveFire =
      NASAServiceSettings(apiKey: NASAServiceSettings.nasaApiKey);

  NASAService() {
    dynamic nasaApiKey = _localStorageService.getItem(StorageKeys.nasaApiKey);
    if (nasaApiKey is String && nasaApiKey.isNotEmpty) {
      nasaApiCountryLiveFire.apiKey = nasaApiKey;
    }
  }

  Future<List<Country>> getCountries() async {
    var request =
        http.Request('GET', Uri.parse(NASAServiceSettings.countriesUrl));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      List<List<dynamic>> convertedRows =
          const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
              .convert(await response.stream.bytesToString());

      /*List<dynamic> rows = convertedRows.first;
      rows = rows.sublist(1, rows.length);
      List<Country> countries;
      var map = rows.map((e) => Country.fromCsv(e));
      countries = map.toList();*/

      List<Country> countries =
          convertedRows.skip(1).map((row) => Country.fromCsv(row)).toList();

      return countries;
    } else {
      print(response.reasonPhrase);
      throw Exception('Failed to load countries: ${response.reasonPhrase}');
    }
  }

  Future<List<SatelliteData>> getLiveFire({String? countryAbbreviation}) async {
    List<SatelliteData> satelliteData = [];
    int satelliteIndex = 0;

    if (countryAbbreviation != null && countryAbbreviation.isNotEmpty) {
      nasaApiCountryLiveFire.country = countryAbbreviation;
    }

    do {
      var request = http.Request(
          'GET',
          Uri.parse(nasaApiCountryLiveFire.generateUrl(
              satelliteIndex: satelliteIndex)));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List<List<dynamic>> convertedRows =
            const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
                .convert(await response.stream.bytesToString());
        satelliteData.addAll(convertedRows
            .skip(1)
            .map((row) => SatelliteData.fromCsv(row))
            .toList());
      } else {
        print(response.reasonPhrase);
        throw Exception(
            'Failed to load satellite data: ${response.reasonPhrase}');
      }

      satelliteIndex++;
    } while (satelliteIndex < NASAServiceSettings.satellites.length);

    return satelliteData;
  }
}
