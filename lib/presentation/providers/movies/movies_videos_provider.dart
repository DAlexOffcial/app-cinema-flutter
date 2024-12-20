import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie_videos.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final moviesVideoProvider = StateNotifierProvider<MovieVideoNotifire, Map<String , List<MovieVideos>>> ((ref) {
  final fetchMovie = ref.watch( movieRepositoryProvider );
  return MovieVideoNotifire( fetchMovieVideo: fetchMovie.getListOfMovieVideos );
});

typedef MovieVideoCallBack = Future<List<MovieVideos>> Function( String movieId);

class MovieVideoNotifire extends StateNotifier<Map<String, List<MovieVideos>>> {
  
  MovieVideoCallBack fetchMovieVideo;

  MovieVideoNotifire({
     required this.fetchMovieVideo
  }) : super({});

  Future<void> loadMovieVideos( String movieId ) async {
    
    if ( state[movieId] != null)  return;
    final List<MovieVideos> movieVideos = await fetchMovieVideo(movieId);
    state = { ...state , movieId: movieVideos};
  }
}