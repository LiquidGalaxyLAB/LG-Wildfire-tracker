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
}