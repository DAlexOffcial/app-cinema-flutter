import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/presentation/providers/theme/theme_provider.dart';


Future<void> main () async {
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context , ref) {
    final AppTheme appTheme = ref.watch(themeNotifireProvider);
    
    return  MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
