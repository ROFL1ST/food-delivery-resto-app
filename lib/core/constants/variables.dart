import 'package:flutter_dotenv/flutter_dotenv.dart';

class Variables {
  static const String appName = 'MyApp';
  static final String baseUrl = dotenv.env['URL_DEV'] ?? '';
}
