import 'package:flutter/cupertino.dart';
import 'package:geocode/geocode.dart';
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
  Address geocodeAddress;

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
    Address? geocodeAddress,
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
        id = '$latitude-$longitude',
        geocodeAddress = geocodeAddress ?? Address();

  factory SatelliteData.fromCsv(List<dynamic> csvRow) {
    double latitude = double.parse(csvRow[1].toString());
    double longitude = double.parse(csvRow[2].toString());
    //dynamic geolocatorPlaceName = placemarkFromCoordinates(latitude, longitude);
    //print('geolocatorPlaceName: $geolocatorPlaceName');
    return SatelliteData(
      countryId: csvRow[0].toString(),
      latitude: latitude,
      longitude: longitude,
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
      //geolocatorPlaceName: geolocatorPlaceName,
    );
  }

  PlacemarkEntity toPlacemarkEntity() {
    return PlacemarkEntity(
      id: '$id'.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      name: '[$countryId] ${geocodeAddress.city != null ? '${geocodeAddress.city} - ':  ''} ${geocodeAddress.countryName ?? ''}',
      point: PointEntity(altitude: 5, lat: latitude, lng: longitude),
      line: LineEntity(id: '', coordinates: []),
      balloonContent: getBallonContent(),
      icon: 'fire.png',
      lookAt: toLookAtEntity(),
      description: 'Live fire',
    );
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
      heading: '5',
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

  KMLEntity toKMLEntity() {
    return KMLEntity(
        name: id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''), content: toPlacemarkEntity().tag);
  }

  String getBallonContent() => '''
  <div>
    <b><span style="font-size:15px;">${countryId}</span></b>
    <br/><br/>
    <b>Latitude:</b> ${latitude.toStringAsFixed(10)}<br/>
    <b>Longitude:</b> ${longitude.toStringAsFixed(10)}<br/>
    <b>Brightness temperature infrared 4:</b> ${brightTi4.toString()}<br/>
    <b>Scan:</b> ${scan.toString()}<br/>
    <b>Track:</b> ${track.toString()}<br/>
    <b>Acquisition date:</b> ${getDateTime()}<br/>
    <b>Acquisition time:</b> ${acqTime.toString()}<br/>
    <b>Satellite:</b> ${satellite}<br/>
    <b>Instrument:</b> ${instrument}<br/>
    <b>Confidence:</b> ${confidence}<br/>
    <b>Version:</b> ${version}<br/>
    <b>Brightness temperature infrared 5:</b> ${brightTi5.toString()}<br/>
    <b>Fire radiative power:</b> ${frp.toString()}<br/>
    <b>Day or night:</b> ${dayNight}<br/>
    <b>Address:</b> ${geocodeAddress.streetAddress != null ? '${geocodeAddress.streetAddress}, ':  ''} 
    ${geocodeAddress.city != null ? '${geocodeAddress.city}, ':  ''} ${geocodeAddress.countryName ?? ''}<br/>
    </div>
  ''';


  /* static  void setPlacemarkFromCoordinates(List<SatelliteData> satelliteData)  async{
    satelliteData.forEach((SatelliteData sd) {
      Address address = GeoCode().reverseGeocoding(latitude: sd.latitude, longitude: sd.longitude);
      Future.delayed(Duration(seconds: 1));
      sd.geocodeAddress = address;
      print('address: $address');
    });
  }*/

  static Future<void> setPlacemarkFromCoordinates(List<SatelliteData> satelliteData, ValueNotifier<bool> isFinish,  VoidCallback refreshState) async {
    for (SatelliteData sd in satelliteData) {
      if (isFinish.value) {
        print("return and stop calling");
        return;
      }

      int i = 0;
      Address address = Address();

      do{
        address = await GeoCode().reverseGeocoding(latitude: sd.latitude, longitude: sd.longitude);
        await Future.delayed(Duration(seconds: i, milliseconds: 1000));
      }while(i++ <= 2 && (address.countryName == null || address.countryName!.toLowerCase().contains('throttled')));

      if (address.countryName != null && !address.countryName!.toLowerCase().contains('throttled')) {
        sd.geocodeAddress = address;
        refreshState();
      }
    }
  }

}