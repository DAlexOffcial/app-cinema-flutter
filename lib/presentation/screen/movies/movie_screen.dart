import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/movies/movies_videos_provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class MovieScreen  extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  
  final String movieId;
  const MovieScreen ({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie( widget.movieId );
    ref.read(actorsByMovieProvider.notifier).loadActors( widget.movieId );
    ref.read(moviesVideoProvider.notifier).loadMovieVideos(widget.movieId);
    
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider)[widget.movieId];

    if (movie == null) return const Scaffold(body: Center(child: CircularProgressIndicator( strokeWidth: 2)));

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
          ))
        ],
      ) ,
    );
  }
} 

class _MovieDetails  extends StatelessWidget {
  final Movie movie; 
  const _MovieDetails ({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox( width: 10),

              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title , style: textStyles.titleLarge),

                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(  right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ))
            ],
          ),
        ),

        _VideosByMovie(movieId: movie.id.toString()),
        
        const SizedBox(height: 10), 

        _ActorsByMovies( movieId: movie.id.toString()),
        const SizedBox(height: 30), 

      ],
    );
  }
}

class _ActorsByMovies  extends ConsumerWidget {
  
  final String movieId;

  const _ActorsByMovies ({required this.movieId});

  @override
  Widget build(BuildContext context , ref) {
 
    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if ( actorsByMovie[movieId] == null ) {
      return const CircularProgressIndicator();
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300,
      child: actors.isEmpty ? const Center(child:  Text('Hubo un problema con los actores'),) : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath, 
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                const SizedBox(
                  height:5
                ),
                Text(actor.name , maxLines: 2 ),
                Text(actor.character ?? '' , maxLines: 2 , style: const TextStyle( fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis) , textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose((ref , int movieId) {
    
    final localStorageRepository = ref.watch( localStorageRepositoryProvider);
    return localStorageRepository.isMovieFavorite(movieId);
 });


class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({ required this.movie });

  @override
  Widget build(BuildContext context, ref) {

    final isFavoriteFuture = ref.watch( isFavoriteProvider(movie.id));
    
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight:  size.height * 0.7 ,
      foregroundColor: Colors.white,
      actions: [
        IconButton(onPressed: ()  async{
          await ref.read( favoriteMoviesProvider.notifier).toogleFavorite(movie);
          ref.invalidate(isFavoriteProvider(movie.id));
        },
        icon: isFavoriteFuture.when(
          loading: () => const CircularProgressIndicator( strokeWidth: 2,),
          data: (isFavorite) => isFavorite ? const Icon(Icons.favorite_rounded , color: Colors.red) : const Icon(Icons.favorite_border), 
          error: (_, __) => throw UnimplementedError(), 
        )
        //,
        //icon: ,
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 5),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if( loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topLeft, 
              stops: [0.0, 0.3],
              colors: [Colors.black54,Colors.transparent,]
            ),

            const _CustomGradient(
              end: Alignment.bottomLeft, 
              begin: Alignment.topRight, 
              stops: [0.0, 0.2],
              colors: [Colors.black54,Colors.transparent,]
            ),

            const _CustomGradient(
              end: Alignment.bottomCenter, 
              begin: Alignment.topCenter, 
              stops: [0.7, 1.0], 
              colors: [Colors.transparent,Colors.black87]
            )
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {

  final Alignment end;
  final Alignment begin;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({ this.end = Alignment.centerRight, this.begin = Alignment.centerRight, required this.stops, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
              child: DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: begin,
                  end: end,
                  stops: stops,
                  colors: colors
                )
              )),
            );
  }
}


class _VideosByMovie extends ConsumerWidget {

  final String movieId;
  const _VideosByMovie({required this.movieId});

  @override
  Widget build(BuildContext context , ref) {

    final textTheme = Theme.of(context).textTheme;

    final movieVideos = ref.watch( moviesVideoProvider );
  
    if ( movieVideos[movieId] == null ) {
      return const CircularProgressIndicator();
    }

    final videos = movieVideos[movieId]!;
    

    return videos.isEmpty ? const Center(child: Text('No hay trailers disponibles')) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(videos[0].name , style: textTheme.titleMedium )
          ),
         _VideoPlayer(videoKey: videos[0].key)

        ],
    );
  
  }
}

class _VideoPlayer extends StatefulWidget {
  final String videoKey;
  const _VideoPlayer({required this.videoKey});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {

  late YoutubePlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
       params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        loop: false,

       )
    );
    _controller.loadVideoById(videoId: widget.videoKey);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}