import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:functional_listener/functional_listener.dart';
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
    registerHandler(
        (MovieManager manager) =>
            manager.updateMoviesCmd.thrownExceptions.where((x) => x != null),
        showErrorDialog);

    /// this Spinner is not really useful here because we already have the pull to
    /// refresh spinner but should show how you could do this with the Command
    registerHandler(
        (MovieManager manager) => manager.updateMoviesCmd.isExecuting,
        showSpinner);

    final movies = watchX((MovieManager manager) => manager.updateMoviesCmd);

    return RefreshIndicator(
      onRefresh: () => get<MovieManager>().updateMoviesCmd.executeWithFuture(),
      child: GridView.extent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
        children: movies.map((movie) => _MovieBox(movie: movie)).toList(),
      ),
    );
  }

  void showErrorDialog(BuildContext context, CommandError error, _) async {
    await showDialog(
        context: context,
        builder: (context) {
          if (error.error is MoviesException) {
            return _ErrorBody(
                message: error?.error?.toString() ?? ' Unknown Error');
          }
          return _ErrorBody(message: "Oops, something unexpected happened");
        });
  }

  static OverlayEntry entry;

  /// this Spinner is not really useful here because we already have the pull to
  /// refresh spinner but should show how you could do this with the Command
  void showSpinner(BuildContext context, bool show, void Function() cancel) {
    if (show) {
      entry ??= OverlayEntry(
        builder: (context) => Center(
          child: Material(
            type: MaterialType.circle,
            color: Colors.white,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(entry);
    } else {
      entry?.remove();
    }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 300),
      child: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message, textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  GetIt.I<MovieManager>().updateMoviesCmd();
                  Navigator.of(context).pop();
                },
                child: Text("Try again"),
              ),
            ],
          ),
        ),
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
