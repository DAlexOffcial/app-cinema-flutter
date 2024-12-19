import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';

final darkOrLightModeProvider =  StateProvider((ref) => false);

final themeNotifireProvider =  StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {

  ThemeNotifier(): super( AppTheme())  ;

  void toggleDarkMode() {
    print('cambio color');
    state =  state.copyWith( isDarkmode: !state.isDarkmode);
  }

}