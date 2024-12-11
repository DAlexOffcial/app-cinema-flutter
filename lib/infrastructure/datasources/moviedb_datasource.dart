import 'package:dio/dio.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mappers.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
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
    } on DioException catch (e) {
      
      return [];
    }
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    try{
      final response = await dio.get('/movie/popular' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException catch (e) {
      
     return [];
    }
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async{
    try{
      final response = await dio.get('/movie/top_rated' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException catch (e) {
      
     return [];
    }
  }
  
  @override
  Future<List<Movie>> getUpComing({int page = 1}) async{
    try{
      final response = await dio.get('/movie/upcoming' , queryParameters: { 'page': page });
      return _jsonToMovies(response.data);
    } on DioException catch (e) {
      
     return [];
    }
  }


}