import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:cinemapedia/presentation/screen/screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [ 
  StatefulShellRoute.indexedStack(
    builder: (context, state, navegationShell)  => HomeScreen(currentChild: navegationShell),
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const HomeView();
            },
            routes: [
              GoRoute(
                path: 'movie/:id',
                name: MovieScreen.name,
                builder: (context, state) { 
                  final movieId = state.pathParameters['id'] ?? 'no-id';
                  
                  return MovieScreen(movieId: movieId); 
                },
              ),
            ]
          ),
        ]
      ),
/*       StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/categories',
            builder: (context, state) {
              return const CategoriesView();
            },
          )
        ]
      ), */
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/favorites',
            builder: (context, state) {
              return const FavoritesView();
            },
          )
        ]
      ),
    ]
  )

  ]
);
