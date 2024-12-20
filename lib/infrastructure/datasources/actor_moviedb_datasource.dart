import 'package:dio/dio.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mappers.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_respoce.dart';

class ActorMoviedbDatasource extends ActorsDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.movieDbKey,
      'language': 'es-MX'
    }
  ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async{

    try{
      final response = await dio.get('/movie/$movieId/credits');
      
      // el from json es cuando tienes la inforamcion aun en json y la convierte a data con el modelo que hice para poder trasformar el json a un tipo de data 
      final castRespoce = CreditsResponse.fromJson(response.data);


      List<Actor> actors = castRespoce.cast.map(
        (cast) => ActorMapper.caseToEntity(cast)
      ).toList();

      return actors;
    } on DioException {
      
      return [];
    }
   
  }

}