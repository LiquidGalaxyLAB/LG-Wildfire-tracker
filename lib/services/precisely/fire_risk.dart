
import 'dart:math';

import '../../entities/kml/kml_entity.dart';
import '../../entities/kml/line_entity.dart';
import '../../entities/kml/look_at_entity.dart';
import '../../entities/kml/orbit_entity.dart';
import '../../entities/kml/placemark_entity.dart';
import '../../entities/kml/point_entity.dart';

class FireRisk {
  String state;
  String noharmId;
  String noharmCls;
  String noharmModel;
  String riskDesc;
  int risk50;
  int severity;
  int frequency;
  int community;
  int damage;
  int mitigation;
  Map<String, dynamic> severityGroupElements;
  Map<String, dynamic> frequencyGroupElements;
  Map<String, dynamic> communityGroupElements;
  Map<String, dynamic> damageGroupElements;
  Map<String, dynamic> mitigationGroupElements;
  Map<String, dynamic> geometry;
  Map<String, dynamic> matchedAddress;
  late double centeredLatitude = 0;
  late double centeredLongitude = 0;
  late double area = 0;

  FireRisk({
    this.state = '',
    this.noharmId = '',
    this.noharmCls = '',
    this.noharmModel = '',
    this.riskDesc = '',
    this.risk50 = 0,
    this.severity = 0,
    this.frequency = 0,
    this.community = 0,
    this.damage = 0,
    this.mitigation = 0,
    this.severityGroupElements = const {},
    this.frequencyGroupElements = const {},
    this.communityGroupElements = const {},
    this.damageGroupElements = const {},
    this.mitigationGroupElements = const {},
    this.geometry = const {},
    this.matchedAddress = const {},
  }){
    if (geometry['coordinates'] == null) return;

    centeredLatitude = geometry['coordinates'][0][0][1];
    centeredLongitude = geometry['coordinates'][0][0][0];

    int length = geometry['coordinates'][0].length;
    double totalLatitude = 0;
    double totalLongitude = 0;
    double tmpArea = 0;
    for (var i = 0; i < geometry['coordinates'][0].length; i++) {
      totalLatitude += geometry['coordinates'][0][i][1];
      totalLongitude += geometry['coordinates'][0][i][0];

      double lon = geometry['coordinates'][0][i][0] * 111000 * cos(geometry['coordinates'][0][i][1] * pi / 180);
      double lat = geometry['coordinates'][0][i][1] * 111000;
      double nextLon = geometry['coordinates'][0][(i + 1) % length][0] * 111000 * cos(geometry['coordinates'][0][(i + 1) % length][1] * pi / 180);
      double nextLat = geometry['coordinates'][0][(i + 1) % length][1] * 111000;

      tmpArea += (lon * nextLat - nextLon * lat);


    }
    centeredLatitude = totalLatitude / geometry['coordinates'][0].length;
    centeredLongitude = totalLongitude / geometry['coordinates'][0].length;

    area = (tmpArea / 2).abs()/10000;
  }

  factory FireRisk.fromJson(Map<String, dynamic> json) {
    return FireRisk(
      state: json['state'] ?? '',
      noharmId: json['noharmId'] ?? '',
      noharmCls: json['noharmCls'] ?? '',
      noharmModel: json['noharmModel'] ?? '',
      riskDesc: json['riskDesc'] ?? '',
      risk50: json['risk50'] ?? 0,
      severity: json['severity'] ?? 0,
      frequency: json['frequency'] ?? 0,
      community: json['community'] ?? 0,
      damage: json['damage'] ?? 0,
      mitigation: json['mitigation'] ?? 0,
      severityGroupElements: json['severityGroupElements'] ?? {},
      frequencyGroupElements: json['frequencyGroupElements'] ?? {},
      communityGroupElements: json['communityGroupElements'] ?? {},
      damageGroupElements: json['damageGroupElements'] ?? {},
      mitigationGroupElements: json['mitigationGroupElements'] ?? {},
      geometry: json['geometry'] ?? {},
      matchedAddress: json['matchedAddress'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'noharmId': noharmId,
      'noharmCls': noharmCls,
      'noharmModel': noharmModel,
      'riskDesc': riskDesc,
      'risk50': risk50,
      'severity': severity,
      'frequency': frequency,
      'community': community,
      'damage': damage,
      'mitigation': mitigation,
      'severityGroupElements': severityGroupElements,
      'frequencyGroupElements': frequencyGroupElements,
      'communityGroupElements': communityGroupElements,
      'damageGroupElements': damageGroupElements,
      'mitigationGroupElements': mitigationGroupElements,
      'geometry': geometry,
      'matchedAddress': matchedAddress,
    };
  }

  // todo: implement methods to convert to kml for LG sending (test with LG)


  KMLEntity toKMLEntity() {
    return KMLEntity(
        name: noharmId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''), content: toPlacemarkEntity().tag);
  }

  PlacemarkEntity toPlacemarkEntity() {
    return PlacemarkEntity(
      id: noharmId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
      name: noharmId,
      point: PointEntity(
          lat: centeredLatitude,
          lng: centeredLongitude,
          altitude: 125),
      line: LineEntity(
          id: noharmId,
          coordinates: getFormatedCoordinates(),
      ),
      layerColor: getColorByRisk(), // color verd
      lookAt: toLookAtEntity(),
      // viewOrbit: true,
      //visibility: true,
      balloonContent: getBallonContent(),
      //'Wildfire',
      icon: 'risk.png',
      description: 'Wildfire risk',
    );
  }

  LookAtEntity toLookAtEntity() { // todo: ajust zoom on LG
    var range = (20 * log(area + 1) * 8);
    if (range < 570) range = 570;
    return LookAtEntity(
      lat: centeredLatitude,
      lng: centeredLongitude,
      altitude: 0, //2,3998
      range:  range.toString(),
      tilt: '65',
      heading: '5',
    );
  }

  String buildOrbit() {
    return OrbitEntity.buildOrbit(OrbitEntity.tag(toLookAtEntity()));
  }

  static getRiskImg() {
    return [
      {
        'name': 'risk.png',
        'path': 'assets/images/risk.png',
      }
    ];
  }

  String getBallonContent() => '''
<div style="font-size:30px;position:relative; padding:10px; border:1px solid #ccc; border-radius:5px; font-family:Arial, sans-serif;">
<table style="width: 100%; margin-top: 20px;">
    <tr>
        <td style="text-align: center; vertical-align: middle;font-size:15px;">Low Risk</td>
        <td style="width: 100%; height: 30px; background: linear-gradient(90deg, rgba(0,255,0,1) 0%, rgba(255,0,0,1) 100%);"></td>
        <td style="text-align: center; vertical-align: middle;font-size:15px;">Very High Risk</td>
    </tr>
</table>
<br/>
<table style="width:100%; border-collapse:collapse;">
  <tr>
    <td style="width:33%; text-align:left; vertical-align:middle;">
      <img src="https://i.imgur.com/4CLoHq1.png" alt="Fire Logo" style="height:100px;"> <!-- logo atencio  -->
    </td>
    <td style="width:34%; text-align:center; vertical-align:middle; font-size:45px; font-weight:bold;">
      Wildfire Risk
    </td>
    <td style="width:33%; text-align:right; vertical-align:middle;">
      <img src="https://i.imgur.com/q4tJFUp.png" alt="Fire Logo" style="height:100px;"> <!-- logo app -->
    </td>
  </tr>
</table>

  <br/>
  <div>
    <b><span style="font-size:40px;">${state.toUpperCase()} - ${noharmId.toUpperCase()}</span></b>
    <br/><br/>
    <b>Model:</b> $noharmModel<br/>
    <b>Risk:</b> $riskDesc<br/>
    <b>Risk level:</b> $risk50<br/>
    <b>Severity:</b> $severity<br/>
    <b>Frequency:</b> $frequency<br/>
    <b>Community:</b> $community<br/>
    <b>Damage:</b> $damage<br/>
    <b>Mitigation:</b> $mitigation<br/>
    <b>Country:</b> ${matchedAddress['country']}<br/>
    <b>Post Code:</b> ${matchedAddress['postalCode']}<br/>
    <b>Street name:</b> ${matchedAddress['streetName']}<br/>
    <b>Complete street:</b> ${matchedAddress['formattedAddress']}<br/>
    </div>
</div>
''';

  // todo: test on LG the color
  String getColorByRisk() {
    int red;
    int green;

    if (risk50 <= 25) {
      // Transition from green (#008000) to yellow (#FFFF00)
      red = (risk50 / 25 * 255).round();
      green = 128 + ((risk50 / 25) * 127).round();
    } else {
      // Transition from yellow (#FFFF00) to red (#FF0000)
      red = 255;
      green = ((50 - risk50) / 25 * 255).round();
    }
    // trans/blau/verd/vermell
    var color =  'c200${green.toRadixString(16).padLeft(2, '0')}${red.toRadixString(16).padLeft(2, '0')}';
    return color;
  }


  getFormatedCoordinates() {
    List<Map<String, double>> formatedCoordinates = [];
    for (var i = 0; i < geometry['coordinates'][0].length; i++) {
      formatedCoordinates.add({
        'lat': geometry['coordinates'][0][i][1],
        'lng': geometry['coordinates'][0][i][0],
        'altitude': 99.0,
      });
    }
    return formatedCoordinates;
  }

}