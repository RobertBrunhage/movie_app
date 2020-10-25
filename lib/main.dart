import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movieapp/environment_config.dart';
import 'package:movieapp/home/movie_service.dart';

import 'movie_app.dart';

void main() {
  setUpLocator();
  runApp(MovieApp());
}

void setUpLocator() {
  GetIt.I.registerSingleton(EnvironmentConfig());
  GetIt.I.registerSingleton(MovieService());
  GetIt.I.registerSingleton(MovieManager());
}
