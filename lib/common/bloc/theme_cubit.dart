import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial(false)) {
    _loadTheme();
  }

  static const String _themeKey = 'isDarkMode';

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = !state.isDarkMode;
    await prefs.setBool(_themeKey, isDarkMode);
    emit(ThemeInitial(isDarkMode));
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    emit(ThemeInitial(isDarkMode));
  }
}
