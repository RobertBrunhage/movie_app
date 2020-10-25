import 'package:dio/dio.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:get_it/get_it.dart';
import 'package:movieapp/environment_config.dart';
import 'package:movieapp/home/movies_exception.dart';

import 'movie.dart';

class MovieService {
  MovieService([this._environmentConfig, this._dio]) {
    _environmentConfig ??= GetIt.I<EnvironmentConfig>();
    _dio ??= Dio();
  }

  EnvironmentConfig _environmentConfig;
  Dio _dio;

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
}

class MovieManager {
  Command<void, List<Movie>> updateMoviesCmd;

  MovieManager() {
    updateMoviesCmd = Command.createAsyncNoParam(
        () => GetIt.I<MovieService>().getMovies(), []);
    updateMoviesCmd();
  }
}
