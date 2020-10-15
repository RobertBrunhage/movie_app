import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import 'movie_app.dart';

void main() {
  runApp(ProviderScope(child: MovieApp()));
}
