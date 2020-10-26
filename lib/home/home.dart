import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:movieapp/home/movie_service.dart';
import 'package:movieapp/home/movies_exception.dart';

import 'movie.dart';

class HomePage extends StatelessWidget with GetItMixin {
  @override
  Widget build(
    BuildContext context,
  ) {
    /// watchX will make sure that this Widget is rebuild whenever the state of the
    /// `updateMoviesCmd` changed.
    final movies =
        watchX((MovieManager manager) => manager.updateMoviesCmd.results);

    /// this here shows the most manual way to build with data of a Command
    /// for more elegant possibilities please check out hom2.dart and home3.dart
    if (movies.hasError) {
      if (movies.error is MoviesException) {
        return _ErrorBody(message: movies.error.toString());
      }
      return _ErrorBody(message: "Oops, something unexpected happened");
    }
    if (movies.isExecuting) {
      return Center(child: CircularProgressIndicator());
    }
    assert(movies.hasData);
    return RefreshIndicator(
      onRefresh: () => get<MovieManager>().updateMoviesCmd.executeWithFuture(),
      child: GridView.extent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
        children: movies.data.map((movie) => _MovieBox(movie: movie)).toList(),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            // for just one access to GetIt the Mixin would be overkill
            onPressed: GetIt.I<MovieManager>().updateMoviesCmd,
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: movie.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
