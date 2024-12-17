import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final seachedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifire, List<Movie>>((ref) {

  final movieRepository = ref.read( movieRepositoryProvider );
  
  return SearchedMoviesNotifire(
    searchMovies: movieRepository.getSearchMovies, 
    ref: ref
  );
});

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifire extends StateNotifier<List<Movie>> {

  final SearchMovieCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifire({
    required this.searchMovies, 
    required this.ref
  }): super([]);

  Future<List<Movie>> searchMoviesByQuery( String query ) async {

    final List<Movie> movies = await searchMovies(query);
    
    ref.read( searchQueryProvider.notifier).update((state) => query);
    
    state = movies;
    return movies; 
  }
}