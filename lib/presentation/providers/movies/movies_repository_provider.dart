import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movies_repository_impl.dart';

//Este repository es inmutable
final movieRepositoryProvider = Provider((ref) {
  return MoviesRepositoryImpl( MoviedbDatasource());
});