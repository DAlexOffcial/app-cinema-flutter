import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_respoce.dart';

class ActorMapper {
  static Actor caseToEntity(Cast cast) => Actor(
    id: cast.id, 
    name: cast.name, 
    profilePath: cast.profilePath != null ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}' : 'https://icon-library.com/images/no-profile-pic-icon/no-profile-pic-icon-10.jpg', 
    character: cast.character
  );
}