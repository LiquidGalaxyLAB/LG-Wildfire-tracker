import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PreciselyServiceSettings {
  static String defaultApiKey = dotenv.get('PRECISELY_API_KEY');
  static String defaultApiSecret = dotenv.get('PRECISELY_API_SECRET');

  String apiKey;
  String apiSecret;

  static String fireRiskUrl =
      "https://api.precisely.com/risks/v2/fire/byaddress";
  static String fireRiskLocationUrl =
      "https://api.precisely.com/risks/v2/fire/bylocation";
  static String oAuthTokenUrl = "https://api.precisely.com/oauth/token";

  PreciselyServiceSettings({
    required this.apiKey,
    required this.apiSecret,
  });

  String preciselyApiKey() {
    return base64.encode(utf8.encode('$apiKey:$apiSecret'));
  }
}
