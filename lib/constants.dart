import 'package:flutter_dotenv/flutter_dotenv.dart';

// lib/constants.dart
class Env {
  static final Env _singleton = Env._internal();

  factory Env() {
    return _singleton;
  }

  Env._internal();

  String get baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_BASE_URL not found in .env file');
    }
    return url;
  }
}
