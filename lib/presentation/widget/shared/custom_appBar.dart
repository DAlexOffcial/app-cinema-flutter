import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context , ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final bool darkOrLightMode = ref.watch( themeNotifireProvider ).isDarkmode;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                 icon: darkOrLightMode ?  Icon( Icons.dark_mode_outlined , color: colors.primary) :  Icon( Icons.light_mode_outlined , color: colors.primary) ,
                 onPressed: () {
                  ref.read( themeNotifireProvider.notifier ).toggleDarkMode();
                }, 
              ),
              const SizedBox(width: 10),
              Icon( Icons.movie_outlined, color: colors.primary ),
              const SizedBox( width: 5,),
              Text('Cinemapedia', style: titleStyle,),
      
              const Spacer(),
      
              IconButton(onPressed: () {

                final searchedMovies = ref.read( seachedMoviesProvider );
                final searchQuery = ref.read(searchQueryProvider);

                showSearch<Movie?>(
                  query: searchQuery,
                  context: context, 
                  delegate: SearchMovieDelegate( 
                    initialMovies: searchedMovies,
                    getSearchMovies: ref.read( seachedMoviesProvider.notifier ).searchMoviesByQuery,
                  ),
                ).then( (movie) {
                  if(movie == null) return;
                  context.push('/movie/${movie.id}');
                });

              }, 
              icon: const Icon(Icons.search))
            ],
          ),
        ),
      ),
    );
  }
}
