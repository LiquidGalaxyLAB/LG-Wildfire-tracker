import '../../entities/kml/kml_entity.dart';
import '../../entities/kml/line_entity.dart';
import '../../entities/kml/look_at_entity.dart';
import '../../entities/kml/orbit_entity.dart';
import '../../entities/kml/placemark_entity.dart';
import '../../entities/kml/point_entity.dart';
import '../../entities/kml/tour_entity.dart';

class FirePerimeter {
  String type;
  Properties properties;
  Geometry geometry;

  FirePerimeter({required this.type, required this.properties, required this.geometry});

  factory FirePerimeter.fromJson(Map<String, dynamic> json) {
    return FirePerimeter(
      type: json['type'],
      properties: Properties.fromJson(json['properties']),
      geometry: Geometry.fromJson(json['geometry']),
    );
  }

  KMLEntity toKMLEntity() {
    return KMLEntity(
        name: properties.codiFinal,
        content: PlacemarkEntity(
          id:  properties.codiFinal.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
          name:  properties.codiFinal,
          point: PointEntity(lat: geometry.coordinates[0][0][0][1], lng: geometry.coordinates[0][0][0][0], altitude: 2000),
          line: LineEntity(id: properties.codiFinal, coordinates: geometry.getFormatedCoordinates()),
          // lookAt: toLookAtEntity(),
          //viewOrbit: true,
          //visibility: true,
          //balloonContent: 'Wildfire',
          icon: 'fire.png',
          description: ' test',

        ).tag);
  }

  LookAtEntity toLookAtEntity() {
    return LookAtEntity(
      lat: geometry.coordinates[0][0][0][1],
      lng: geometry.coordinates[0][0][0][0],
      altitude: 2000,
      range: '2000',
      tilt: '60',
      heading: '0',
    );
  }

  String buildOrbit() {
    return OrbitEntity.buildOrbit(OrbitEntity.tag(toLookAtEntity()));
  }

  @override
  String toString() {
    return 'FirePerimeter{type: $type, properties: $properties, geometry: $geometry}';
  }

}

class Properties {
  String codiFinal;
  String dataIncen;
  String municipi;
  int gridCode;

  Properties({required this.codiFinal, required this.dataIncen, required this.municipi, required this.gridCode});

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      codiFinal: json['CODI_FINAL'],
      dataIncen: json['DATA_INCEN'],
      municipi: json['MUNICIPI'],
      gridCode: json['GRID_CODE'],
    );
  }

  @override
  String toString() {
    return 'Properties{codiFinal: $codiFinal, dataIncen: $dataIncen, municipi: $municipi, gridCode: $gridCode}';
  }
}

class Geometry {
  String type;
  List<List<List<List<double>>>> coordinates;

  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: List<List<List<List<double>>>>.from(json['coordinates'].map((x) => List<List<List<double>>>.from(x.map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble())))))))),
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
        'altitude': 2000.0,
      });
    }
    //formatedCoordinates.add(formatedCoordinates.first);
    print(formatedCoordinates);
    return formatedCoordinates;
  }
}