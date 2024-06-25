
import 'dart:convert';

class PreciselyServiceSettings {
  // base64 ( nceA63Z017WJ8uzBINPZacIVeHYcJ0AE:0Ms1D9NeXdLeOkyJ)
  static String defaultApiKey = 'nceA63Z017WJ8uzBINPZacIVeHYcJ0AE';
  static String defaultApiSecret = '0Ms1D9NeXdLeOkyJ';

  String apiKey;
  String apiSecret;

  static String fireRiskUrl = "https://api.precisely.com/risks/v2/fire/byaddress";
  static String fireRiskLocationUrl = "https://api.precisely.com/risks/v2/fire/bylocation";
  static String oAuthTokenUrl = "https://api.precisely.com/oauth/token";

  PreciselyServiceSettings({
    required this.apiKey,
    required this.apiSecret,
  });

  String preciselyApiKey() {
    return base64.encode(utf8.encode('$apiKey:$apiSecret'));
  }


}