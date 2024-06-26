import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:wildfiretracker/services/precisely/fire_risk.dart';
import 'package:wildfiretracker/services/precisely/precisely_service_settings.dart';
import 'package:http/http.dart' as http;

import '../../utils/storage_keys.dart';
import '../local_storage_service.dart';

class PreciselyService {
  LocalStorageService get _localStorageService =>
      GetIt.I<LocalStorageService>();

  PreciselyServiceSettings preciselyApiServiceSettings =
      PreciselyServiceSettings(
          apiKey: PreciselyServiceSettings.defaultApiKey,
          apiSecret: PreciselyServiceSettings.defaultApiSecret);

  PreciselyService() {
    dynamic precieslyApiKey =
        _localStorageService.getItem(StorageKeys.preciselyApiKey);
    dynamic precieslyApiSecret =
        _localStorageService.getItem(StorageKeys.preciselyApiSecret);
    if (precieslyApiKey is String &&
        precieslyApiKey.isNotEmpty &&
        precieslyApiSecret is String &&
        precieslyApiSecret.isNotEmpty) {
      preciselyApiServiceSettings.apiKey = precieslyApiKey;
      preciselyApiServiceSettings.apiSecret = precieslyApiSecret;
    }
  }

  Future<FireRisk> getFireRisk(String address, LatLng? latLng) async {
    // todo: implement getFireRisk
    // includeGeometry=Y&address=Death Valley National Park, USA

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await getSessionOAuthToken() ?? ''}'
    };
    
    print(headers);

    var url = Uri.parse(
    '${PreciselyServiceSettings.fireRiskUrl}?includeGeometry=Y&address=$address');
    if (latLng != null) {
      url = Uri.parse(
          '${PreciselyServiceSettings.fireRiskLocationUrl}?includeGeometry=Y&longitude=${latLng.longitude}&latitude=${latLng.latitude}');
    }

    print(url);

    var request = Request('GET', url);
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return FireRisk.fromJson(jsonDecode(await response.stream.bytesToString()));
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
      throw Exception('Failed to load fire risk: ${response.reasonPhrase}');
    }
  }

  Future<String> getBearer() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Basic ${preciselyApiServiceSettings.preciselyApiKey()}'
    };
    var request =
        http.Request('POST', Uri.parse(PreciselyServiceSettings.oAuthTokenUrl));
    request.bodyFields = {'grant_type': 'client_credentials'};
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())['access_token'];
    } else {
      if (kDebugMode) print(response.reasonPhrase);
      throw Exception('Failed to get oauth token: ${response.reasonPhrase}');
    }
  }

  Future<bool?> setSessionOAuthToken(String token) async {
    try {
      await _localStorageService.setItem(
          StorageKeys.preciselyOAuthToken, token);
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }

  Future<String?> getSessionOAuthToken() async {
    return await getBearer(); // todo: expiresIn element
    var oauthToken = _localStorageService.getItem(StorageKeys.preciselyOAuthToken);
    if (oauthToken == null || oauthToken.isEmpty) {
      oauthToken = await getBearer();
      await setSessionOAuthToken(oauthToken);
    }
    return oauthToken;
  }
}
