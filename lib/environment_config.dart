import 'package:binder/binder.dart';

class EnvironmentConfig {
  // We add the api key by running 'flutter run --dart-define=movieApiKey=MYKEY
  final movieApiKey = const String.fromEnvironment("movieApiKey");
}

final environmentConfigRef = StateRef(EnvironmentConfig());
