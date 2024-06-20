
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
  late double centeredLatitude;
  late double centeredLongitude;
  late double area = 0;

  FireRisk({
    required this.state,
    required this.noharmId,
    required this.noharmCls,
    required this.noharmModel,
    required this.riskDesc,
    required this.risk50,
    required this.severity,
    required this.frequency,
    required this.community,
    required this.damage,
    required this.mitigation,
    required this.severityGroupElements,
    required this.frequencyGroupElements,
    required this.communityGroupElements,
    required this.damageGroupElements,
    required this.mitigationGroupElements,
    required this.geometry,
    required this.matchedAddress,
  });

  factory FireRisk.fromJson(Map<String, dynamic> json) {
    return FireRisk(
      state: json['state'],
      noharmId: json['noharmId'],
      noharmCls: json['noharmCls'],
      noharmModel: json['noharmModel'],
      riskDesc: json['riskDesc'],
      risk50: json['risk50'],
      severity: json['severity'],
      frequency: json['frequency'],
      community: json['community'],
      damage: json['damage'],
      mitigation: json['mitigation'],
      severityGroupElements: json['severityGroupElements'],
      frequencyGroupElements: json['frequencyGroupElements'],
      communityGroupElements: json['communityGroupElements'],
      damageGroupElements: json['damageGroupElements'],
      mitigationGroupElements: json['mitigationGroupElements'],
      geometry: json['geometry'],
      matchedAddress: json['matchedAddress'],
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
          altitude: 25),
      line: LineEntity(
          id: noharmId,
          coordinates: geometry['coordinates'],
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

  LookAtEntity toLookAtEntity() {
    return LookAtEntity(
      lat: centeredLatitude,
      lng: centeredLongitude,
      altitude: 20 * log(area + 1), //2,3998
      range: (20 * log(area + 1) * 35.99).toString(),
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
        'name': 'risk.png',
        'path': 'assets/images/risk.png',
      }
    ];
  }

  String getBallonContent() => '''
  <div>
    <b><span style="font-size:15px;">${state.toUpperCase()} - ${noharmId.toUpperCase()}</span></b>
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
  ''';

  String getColorByRisk() {
    return '7d00ffff';
    // todo: test this !!!!
    int red = (risk50 / 50 * 255).round();
    int green = ((50 - risk50) / 50 * 255).round();
    return 'ff${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}00';
  }

}