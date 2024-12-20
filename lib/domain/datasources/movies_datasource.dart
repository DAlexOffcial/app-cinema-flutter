import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_videos.dart';

abstract class MoviesDatasource {

  Future<List<Movie>> getNowPlaying({ int page = 1});

  Future<List<Movie>> getPopular({ int page = 1});

  Future<List<Movie>> getUpComing({ int page = 1});

  Future<List<Movie>> getTopRated({ int page = 1});

  Future<Movie> getMovieById( String id );
  
  Future<List<Movie>> getSearchMovies( String query);

  Future<List<MovieVideos>> getListOfMovieVideos( String id);

}