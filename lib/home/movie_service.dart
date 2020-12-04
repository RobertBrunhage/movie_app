import 'package:binder/binder.dart';
import 'package:dio/dio.dart';
import 'package:movieapp/environment_config.dart';
import 'package:movieapp/home/movies_exception.dart';

import '../environment_config.dart';
import 'movie.dart';

final errorRef = StateRef<String>(null);

final moviesRef = StateRef<List<Movie>>(null);

final movieServiceRef = LogicRef((scope) => MovieService(scope, Dio()));

class MovieService with Logic implements Loadable {
  const MovieService(this.scope, this._dio);

  @override
  final Scope scope;

  final Dio _dio;

  EnvironmentConfig get _environmentConfig => read(environmentConfigRef);

  Future<List<Movie>> getMovies() async {
    try {
      final response = await _dio.get(
        "https://api.themoviedb.org/3/movie/popular?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=1",
      );

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<Movie> movies = results
          .map((movieData) => Movie.fromMap(movieData))
          .toList(growable: false);
      return movies;
    } on DioError catch (dioError) {
      throw MoviesException.fromDioError(dioError);
    }
  }

  @override
  Future<void> load() async {
    try {
      final movies = await getMovies();
      write(moviesRef, movies);
      write(errorRef, null);
    } on MoviesException catch (exception) {
      write(errorRef, exception.message);
    } catch (exception) {
      write(errorRef, 'Oops, something unexpected happened');
    }
  }
}
