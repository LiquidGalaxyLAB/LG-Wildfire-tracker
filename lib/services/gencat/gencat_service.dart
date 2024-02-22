import 'dart:convert';

import 'package:flutter/services.dart';

import 'fire_perimeter.dart';

class GencatService {

  Future<List<FirePerimeter>> getFirePerimeters(String? filename) async {
    final String json = await rootBundle.loadString('assets/gencat/$filename.json');
    final Map<String, dynamic> jsonDecoded = jsonDecode(json);
    //List<FirePerimeter> test = jsonDecoded["features"].map((feature) => FirePerimeter.fromJson(feature)).toList();
    List<FirePerimeter> firePerimeters = [];
    jsonDecoded["features"].forEach((feature) {
      firePerimeters.add(FirePerimeter.fromJson(feature));
    });
    return firePerimeters;
  }


}