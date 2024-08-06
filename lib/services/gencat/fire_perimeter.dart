import 'dart:math';

import '../../entities/kml/kml_entity.dart';
import '../../entities/kml/line_entity.dart';
import '../../entities/kml/look_at_entity.dart';
import '../../entities/kml/orbit_entity.dart';
import '../../entities/kml/placemark_entity.dart';
import '../../entities/kml/point_entity.dart';

class FirePerimeter {
  String type;
  Properties properties;
  Geometry geometry;

  FirePerimeter(
      {required this.type, required this.properties, required this.geometry});

  factory FirePerimeter.fromJson(Map<String, dynamic> json) {
    return FirePerimeter(
      type: json['type'],
      properties: Properties.fromJson(json['properties']),
      geometry: Geometry.fromJson(json['geometry']),
    );
  }

  KMLEntity toKMLEntity() {
    return KMLEntity(
        name: properties.municipi.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
        content: toPlacemarkEntity().tag);
  }

  PlacemarkEntity toPlacemarkEntity() {
    return PlacemarkEntity(
      id: properties.codiFinal.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      name: properties.municipi,
      point: PointEntity(
          lat: geometry.centeredLatitude,
          lng: geometry.centeredLongitude,
          altitude: 25),
      line: LineEntity(
          id: properties.codiFinal,
          coordinates: geometry.getFormatedCoordinates()),
      lookAt: toLookAtEntity(),
      // viewOrbit: true,
      // color vermell translucid
      layerColor: 'c20000ff', // vermell translucid
      //visibility: true,
      balloonContent: getBallonContent(),
      //'Wildfire',
      icon: 'fire.png',
      description: 'Wild fire perimeter',
    );
  }

  LookAtEntity toLookAtEntity() {
    //print("min range: " + (20 * log(geometry.area + 1) * 8).toString());
    var range = (20 * log(geometry.area + 1) * 8);
    if (range < 570) range = 570;
    return LookAtEntity(
      lat: geometry.centeredLatitude,
      lng: geometry.centeredLongitude,
      altitude: 0,
      //2,3998
      range: range.toString(),
      tilt: '65',
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

  @override
  String toString() {
    return 'FirePerimeter{type: $type, properties: $properties, geometry: $geometry}';
  }

  String getBallonContent() => '''
<div style="font-size:30px;position:relative; padding:10px; border:1px solid #ccc; border-radius:5px; font-family:Arial, sans-serif;">
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="width:33%; text-align:left; vertical-align:middle;">
      <img src="https://i.imgur.com/M9DHvEi.png" alt="Fire Logo" style="height:100px;"> <!-- logo foc -->
    </td>
    <td style="width:34%; text-align:center; vertical-align:middle; font-size:45px; font-weight:bold;">
      Fire Perimeter
    </td>
    <td style="width:33%; text-align:right; vertical-align:middle;">
      <img src="https://i.imgur.com/q4tJFUp.png" alt="Fire Logo" style="height:100px;"> <!-- logo app -->
    </td>
  </tr>
</table>
  <br/>
  <div>
    <b><span style="font-size:40px;">${properties.municipi.toUpperCase()}</span></b>
    <br/><br/>
    <b>Wildfire date:</b> ${properties.dataIncen}<br/>
    <b>Wildfire code:</b> ${properties.codiFinal}<br/>
    <b>Wildfire name:</b> ${properties.municipi}<br/>
    <b>Wildfire description:</b> ${properties.description}<br/>
    <b>Wildfire grid code:</b> ${properties.gridCode}<br/>
    <b>Centered latitude:</b> ${geometry.centeredLatitude.toString().substring(0, 10)}<br/>
    <b>Centered longitude:</b> ${geometry.centeredLongitude.toString().substring(0, 10)}<br/>
    <b>Area:</b> ${geometry.area.toString().substring(0, 8)} ha<br/>
    </div>
</div>
''';
}

class Properties {
  String name;
  String description;
  String codiFinal;
  String dataIncen;
  String municipi;
  String gridCode;

  Properties(
      {String? name,
      String? description,
      String? codiFinal,
      String? dataIncen,
      String? municipi,
      String? gridCode})
      : name = name ?? '',
        codiFinal = codiFinal ?? '',
        dataIncen = dataIncen ?? '',
        municipi = municipi ?? '',
        gridCode = gridCode ?? '',
        description = description ?? '';

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      codiFinal: (json['CODI_FINAL'] ?? json['Name']).toString(),
      dataIncen: json['DATA_INCEN'] ?? '',
      municipi: (json['MUNICIPI'] ?? json['MUNICIPI_D'] ?? '').toString(),
      gridCode: (json['GRID_CODE'] ?? '').toString(),
      name: (json['Name'] ?? '').toString(),
      description: json['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Properties{codiFinal: $codiFinal, dataIncen: $dataIncen, municipi: $municipi, gridCode: $gridCode}';
  }
}

class Geometry {
  late String type;
  late double centeredLatitude;
  late double centeredLongitude;
  late double area = 0;

  late List<List<List<List<double>>>> coordinates;

  Geometry({required this.type, required this.coordinates}) {
    centeredLatitude = coordinates[0][0][0][1];
    centeredLongitude = coordinates[0][0][0][0];

    int length = coordinates[0][0].length;
    double totalLatitude = 0;
    double totalLongitude = 0;
    double tmpArea = 0;
    for (var i = 0; i < coordinates[0][0].length; i++) {
      totalLatitude += coordinates[0][0][i][1];
      totalLongitude += coordinates[0][0][i][0];

      double lon = coordinates[0][0][i][0] *
          111000 *
          cos(coordinates[0][0][i][1] * pi / 180);
      double lat = coordinates[0][0][i][1] * 111000;
      double nextLon = coordinates[0][0][(i + 1) % length][0] *
          111000 *
          cos(coordinates[0][0][(i + 1) % length][1] * pi / 180);
      double nextLat = coordinates[0][0][(i + 1) % length][1] * 111000;

      tmpArea += (lon * nextLat - nextLon * lat);
    }
    centeredLatitude = totalLatitude / coordinates[0][0].length;
    centeredLongitude = totalLongitude / coordinates[0][0].length;

    area = (tmpArea / 2).abs() / 10000;
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    var type = json['type'];

    List<List<List<List<double>>>> coordinates = [];

    if (type == 'Polygon') {
      coordinates =
          List<List<List<List<double>>>>.from(json['coordinates'].map((x) => [
                List<List<double>>.from(
                    x.map((x) => List<double>.from(x.map((x) => x.toDouble()))))
              ]));
    } else if (type == 'MultiPolygon') {
      coordinates = List<List<List<List<double>>>>.from(json['coordinates'].map(
          (x) => List<List<List<double>>>.from(x.map((x) =>
              List<List<double>>.from(x.map(
                  (x) => List<double>.from(x.map((x) => x.toDouble()))))))));
    }

    return Geometry(
      type: type,
      coordinates: coordinates,
    );
  }

  @override
  String toString() {
    return 'Geometry{type: $type, coordinates: $coordinates}';
  }

  getFormatedCoordinates() {
    List<Map<String, double>> formatedCoordinates = [];
    for (var i = 0; i < coordinates[0][0].length; i++) {
      formatedCoordinates.add({
        'lat': coordinates[0][0][i][1],
        'lng': coordinates[0][0][i][0],
        'altitude': 20.0,
      });
    }
    return formatedCoordinates;
  }
}
