import 'package:intl/intl.dart';

import '../../entities/kml/kml_entity.dart';
import '../../entities/kml/line_entity.dart';
import '../../entities/kml/look_at_entity.dart';
import '../../entities/kml/orbit_entity.dart';
import '../../entities/kml/placemark_entity.dart';
import '../../entities/kml/point_entity.dart';

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
  })  : countryId = countryId ?? '',
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
      countryId: csvRow[0].toString(),
      latitude: double.parse(csvRow[1].toString()),
      longitude: double.parse(csvRow[2].toString()),
      brightTi4: double.parse(csvRow[3].toString()),
      scan: double.parse(csvRow[4].toString()),
      track: double.parse(csvRow[5].toString()),
      acqDate: DateTime.parse(csvRow[6].toString()),
      acqTime: int.parse(csvRow[7].toString()),
      satellite: csvRow[8].toString(),
      instrument: csvRow[9].toString(),
      confidence: csvRow[10].toString(),
      version: csvRow[11].toString(),
      brightTi5: double.parse(csvRow[12].toString()),
      frp: double.parse(csvRow[13].toString()),
      dayNight: csvRow[14].toString(),
    );
  }

  KMLEntity toPlacemarkEntity() {
    return KMLEntity(
        name: id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
        content: PlacemarkEntity(
          id: '$latitude-$longitude',
          name: '',
          point: PointEntity(altitude: 5, lat: latitude, lng: longitude),
          line: LineEntity(id: '', coordinates: []),
          balloonContent: 'Live Fire',
          icon: 'fire.png',
        ).tag);
  }

  @override
  String toString() {
    return 'SatelliteData{countryId: $countryId, latitude: $latitude, longitude: $longitude, brightTi4: $brightTi4, '
        'scan: $scan, track: $track, acqDate: $acqDate, acqTime: $acqTime, satellite: $satellite, '
        'instrument: $instrument, confidence: $confidence, version: $version, brightTi5: $brightTi5, frp: $frp, dayNight: $dayNight}';
  }

  getDateTime() {
    return DateFormat('dd/MM/yy').format(acqDate!);
  }

  LookAtEntity toLookAtEntity() {
    return LookAtEntity(
      lat: latitude,
      lng: longitude,
      //altitude: 0,
      range: '1500',
      tilt: '60',
      heading: '0',
    );
  }

  String buildOrbit() {
    return OrbitEntity.buildOrbit(OrbitEntity.tag(toLookAtEntity()));
  }

  static getFireImg() {
    return [
      {
        'name': 'fire.png',
        'path': 'assets/images/fire.png',
      }
    ];
  }
}