import 'package:dio/dio.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_videos.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mappers.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_videos.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_detail.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_responce.dart';

class MoviedbDatasource extends MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-MX'
    }
  ));


  List<Movie> _jsonToMovies( Map<String, dynamic> json) {

    final movieDbResponce = MovieDbResponce.fromJson(json);

    final List<Movie> movies = movieDbResponce.results
    .where((movieDb) => movieDb.posterPath != 'no-poster')
    .map((movieDb) => MovieMappers.movieDBToEntity(movieDb))
    .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    try{
      final response = await dio.get('/movie/now_playing' , queryParameters: { 'page': page });
      
      return _jsonToMovies(response.data);
    } on DioException {
      
      return [];
    }
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    try{
      final response = await dio.get('/movie/popular' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException {
      
     return [];
    }
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    try{
      final response = await dio.get('/movie/top_rated' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException {
      
     return [];
    }
  }
  
  @override
  Future<List<Movie>> getUpComing({int page = 1}) async{
    try{
      final response = await dio.get('/movie/upcoming' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException {
      
     return [];
    }
  }
  
  @override
  Future<Movie> getMovieById(String id) async{
    try{
      final response = await dio.get('/movie/$id');
      print('consultado peliculas');
      final movdieDetails = MovieDetails.fromJson(response.data);
      final Movie movie = MovieMappers.movieDetailsToEntity(movdieDetails);
      //final Movie movie = MovieMapper
      return movie;
    } on DioException {
      return Movie(
        adult: false,
        backdropPath: '',
        genreIds: [],
        id: 0,
        originalLanguage: '',
        originalTitle: '',
        overview: '',
        popularity: 0.0,
        posterPath: '',
        releaseDate: DateTime(1970, 1, 1),
        title: '',
        video: false,
        voteAverage: 0.0,
        voteCount: 0,
      );
    }
  }
  
  @override
  Future<List<Movie>> getSearchMovies(String query) async {
    try{

      if(query.isEmpty) return [];
      final response = await dio.get('/search/movie' , queryParameters: { 'query': query });
      return _jsonToMovies(response.data);
    } on DioException {
      
     return [];
    }
  }

  @override
  Future<List<MovieVideos>> getListOfMovieVideos(String id) async {
    try {
      final responce =  await dio.get('/movie/$id/videos');
      final movieVideoResonce = MovieVideoResponce.fromJson(responce.data);
      final movieVideo =  movieVideoResonce.results.map( (video) => MovieMappers.movieVidosToEntity(video)).toList();

      return movieVideo;
      
    } on DioException {
      return [];
    }
  }


}