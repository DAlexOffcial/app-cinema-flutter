import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';


typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback getSearchMovies;

  List<Movie> initialMovies;

  StreamController<List<Movie>> debuncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debonceTimer;

  SearchMovieDelegate({
    required this.getSearchMovies,
    required this.initialMovies 
  });

  void _onQueryChanged( String query )  {
    isLoadingStream.add(true);
    if( _debonceTimer?.isActive ?? false) _debonceTimer!.cancel();
    _debonceTimer = Timer( const Duration(milliseconds: 300), () async {
      //if(query.isEmpty) return debuncedMovies.add([]);
      final movies = await getSearchMovies(query);
      initialMovies = movies;
      debuncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams(){
    debuncedMovies.close();
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream ,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return  SpinPerfect(
              duration: const Duration( seconds: 2),
              spins: 10,
              infinite: true,
              child: IconButton(onPressed: () => query  = '', icon: const Icon(Icons.refresh_outlined))
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(onPressed: () => query  = '', icon: const Icon(Icons.clear))
          );
        },
      )
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null) ;
      }
      , icon: const Icon( Icons.arrow_back_ios_new_outlined)
    );
  }

  Widget _buildResultAndSuggestions(){
    return StreamBuilder(
      initialData: initialMovies,
      stream: debuncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) =>  _MovieItem(movie: movies[index] , 
          onMovieSelected: (context , movie) {
              clearStreams();
              close(context, movie);
            } 
          )
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    _onQueryChanged(query);
    return _buildResultAndSuggestions();
  }
}

class _MovieItem  extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem ({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context , movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10 , vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),
      
                  ( movie.overview.length > 100) ? Text('${movie.overview.substring(0, 100)}...') : Text(movie.overview ),
      
                  Row(
                    children: [
                      Icon( Icons.star_half_outlined, color: Colors.yellow.shade800),
      
                      const SizedBox(width: 5),
                      Text( 
                        HumanFormats.number(movie.voteAverage , 1),
                        style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ), 
            )
          ],
        ),
      ),
    );
  }
}