import 'dart:math' as math;

/// Class that defines the `line` entity, which contains its properties and
/// methods.
class LineEntity {
  /// Property that defines the line `id`.
  String id;

  /// Property that defines the line `coordinates` list.
  List<Map<String, double>> coordinates;

  /// Property that defines the line `draw order`.
  double drawOrder;

  /// Property that defines the line `altitude mode`.
  ///
  /// Defaults to `relativeToGround`.
  String altitudeMode;

  LineEntity({
    required this.id,
    required this.coordinates,
    this.drawOrder = 0,
    this.altitudeMode = 'relativeToGround',
  });

  /// Property that defines the line `tag` according to its current properties.
  ///
  /// Example
  /// ```
  /// LineEntity line = LineEntity(
  ///   id: "123abc",
  ///   coordinates: [
  ///     {
  ///       'lng': 32,
  ///       'lat': -74,
  ///       'altitude': 0,
  ///     },
  ///     {
  ///       'lng': 34,
  ///       'lat': -78,
  ///       'altitude': 0,
  ///     },
  ///   ],
  /// )
  /// line.tag => '''
  ///   <Polygon id="123abc">
  ///     <extrude>0</extrude>
  ///     <altitudeMode>relativeToGround</altitudeMode>
  ///     <outerBoundaryIs>
  ///       <LinearRing>
  ///         <coordinates>
  ///           32,-74,0 34,-78,0
  ///         </coordinates>
  ///       </LinearRing>
  ///     </outerBoundaryIs>
  ///   </Polygon>
  /// '''
  /// ```
  String get tag => '''
      <Polygon id="$id">
        <extrude>0</extrude> 
        <!-- <extrude>1</extrude>
					   <tessellate>1</tessellate>  -->
        <altitudeMode>$altitudeMode</altitudeMode>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              $linearCoordinates
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    ''';

  /// Property that defines the line `linear coordinates` according to its
  /// current [coordinates].
  ///
  /// Example
  /// ```
  /// LineEntity line = LineEntity(
  ///   ...
  ///   coordinates: [
  ///     {
  ///       'lng': 32,
  ///       'lat': -74,
  ///       'altitude': 0,
  ///     },
  ///     {
  ///       'lng': 34,
  ///       'lat': -78,
  ///       'altitude': 0,
  ///     },
  ///   ],
  ///   ...
  /// )
  /// line.linearCoordinates => '32,-74,0 34,-78,0'
  /// ```
  String get linearCoordinates {
    String coords = coordinates
        .map((coord) => '${coord['lng']},${coord['lat']},${coord['altitude']}')
        .join(' ');

    return coords;
  }

  /// Returns a [Map] from the current [LineEntity].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coordinates': coordinates,
      'altitudeMode': altitudeMode,
      'drawOrder': drawOrder,
    };
  }

  /// Returns a [LineEntity] from the given [map].
  factory LineEntity.fromMap(Map<String, dynamic> map) {
    return LineEntity(
      id: map['id'],
      coordinates: map['coordinates'],
      altitudeMode: map['altitudeMode'],
      drawOrder: map['drawOrder'],
    );
  }



  static List<Map<String, double>> createCircle(double lat, double lng, double diameter) {
    final int numPoints = 100;
    final double radius = diameter / 2;
    final double angularDistance = radius / 6371000;
    final double earthRadius = 6371e3; // Earth's radius in meters
    List<Map<String, double>> coordinates = [];

    for (int i = 0; i < numPoints; i++) {
      double theta = (math.pi / 180) * (i * (360 / numPoints));
      double dx = radius * math.cos(theta);
      double dy = radius * math.sin(theta);
      double deltaLongitude = dx / (earthRadius * math.cos(lat));
      double deltaLatitude = dy / earthRadius;
      coordinates.add({
        'lat': lat + deltaLatitude,
        'lng': lng + deltaLongitude,
        'altitude': 20.0,
      });
    }

    return coordinates;
  }



}
