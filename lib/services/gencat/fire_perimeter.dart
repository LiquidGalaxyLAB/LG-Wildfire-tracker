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

  KMLEntity toKMLEntity({bool showBallon = false}) {
    return KMLEntity(
        name: properties.codiFinal, content: toPlacemarkEntity().tag);
  }

  PlacemarkEntity toPlacemarkEntity() {
    return PlacemarkEntity(
      id: properties.codiFinal.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      name: properties.codiFinal,
      point: PointEntity(
          lat: geometry.centeredLatitude,
          lng: geometry.centeredLongitude,
          altitude: 25),
      line: LineEntity(
          id: properties.codiFinal,
          coordinates: geometry.getFormatedCoordinates()),
      lookAt: toLookAtEntity(),
      // viewOrbit: true,
      //visibility: true,
      balloonContent: getBallonContent(),
      //'Wildfire',
      icon: 'fire.png',
      description: ' test',
    );
  }

  LookAtEntity toLookAtEntity() {
    return LookAtEntity(
      lat: geometry.centeredLatitude,
      lng: geometry.centeredLongitude,
      altitude: 200,
      range: '4000',
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

  @override
  String toString() {
    return 'FirePerimeter{type: $type, properties: $properties, geometry: $geometry}';
  }

  String getBallonContent() {
    return '''
      <div style="text-align:center;">
      <b>ÀGER</b>
      <b>Gerard Monsó Salmons</b>
      Fire: properties.codiFinal
      Date: properties.dataIncen
      Municipality: properties.municipi
      Grid Code: properties.gridCode
      </div>
      <br/>
    ''';
  }
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

  late List<List<List<List<double>>>> coordinates;

  Geometry({required this.type, required this.coordinates}) {
    centeredLatitude = coordinates[0][0][0][1];
    centeredLongitude = coordinates[0][0][0][0];

    double totalLatitude = 0;
    double totalLongitude = 0;
    for (var i = 0; i < coordinates[0][0].length; i++) {
      totalLatitude += coordinates[0][0][i][1];
      totalLongitude += coordinates[0][0][i][0];
    }
    centeredLatitude = totalLatitude / coordinates[0][0].length;
    centeredLongitude = totalLongitude / coordinates[0][0].length;
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
