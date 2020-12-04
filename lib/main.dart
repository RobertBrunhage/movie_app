import 'package:flutter/material.dart';
import 'package:binder/binder.dart';

import 'movie_app.dart';

void main() {
  runApp(BinderScope(child: MovieApp()));
}
