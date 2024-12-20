import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_videos.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_detail.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_videos.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMappers {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' : 'https://m.media-amazon.com/images/I/61s8vyZLSzL._AC_SY879_.jpg',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }' : 'https://mir-s3-cdn-cf.behance.net/project_modules/fs/fb3ef66312333.5691dd2253378.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );

  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.backdropPath }' : 'https://m.media-amazon.com/images/I/61s8vyZLSzL._AC_SY879_.jpg',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath != '' ? 'https://image.tmdb.org/t/p/w500${ moviedb.posterPath }' : 'https://m.media-amazon.com/images/I/61s8vyZLSzL._AC_SY879_.jpg',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
  );

  static MovieVideos movieVidosToEntity(MovieVideoResult movieResponce) => MovieVideos(
    iso6391: movieResponce.iso6391, 
    iso31661: movieResponce.iso31661, 
    name: movieResponce.name, 
    key: movieResponce.key != '' ? movieResponce.key : '', 
    site: movieResponce.site, 
    size: movieResponce.size, 
    type: movieResponce.type, 
    official: movieResponce.official, 
    publishedAt: movieResponce.publishedAt, 
    id: movieResponce.id
  );
}
