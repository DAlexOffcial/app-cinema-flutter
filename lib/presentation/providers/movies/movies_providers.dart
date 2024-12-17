import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifire, List<Movie>> ((ref) {
  final fetchMoreMovie = ref.watch( movieRepositoryProvider ).getNowPlaying;
  return MoviesNotifire(
    fetchMoreMovie: fetchMoreMovie
  );
});

final popularMoviesProvider = StateNotifierProvider<MoviesNotifire, List<Movie>> ((ref) {
  final fetchMoreMovie = ref.watch( movieRepositoryProvider ).getPopular;
  return MoviesNotifire(
    fetchMoreMovie: fetchMoreMovie
  );
});

final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifire, List<Movie>> ((ref) {
  final fetchMoreMovie = ref.watch( movieRepositoryProvider ).getUpComing;
  return MoviesNotifire(
    fetchMoreMovie: fetchMoreMovie
  );
});

final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifire, List<Movie>> ((ref) {
  final fetchMoreMovie = ref.watch( movieRepositoryProvider ).getTopRated;
  return MoviesNotifire(
    fetchMoreMovie: fetchMoreMovie
  );
});

typedef MovieCallBack = Future<List<Movie>> Function({ int page});

class MoviesNotifire extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading = false;
  MovieCallBack fetchMoreMovie;


  MoviesNotifire({
    required this.fetchMoreMovie
  }) : super([]);

  Future<void> loadNextPage() async{
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movie = await fetchMoreMovie(page: currentPage);
    state = [...state, ...movie];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}