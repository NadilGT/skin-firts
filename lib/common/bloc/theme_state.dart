part of 'theme_cubit.dart';

abstract class ThemeState {
  final bool isDarkMode;
  const ThemeState(this.isDarkMode);
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(super.isDarkMode);
}
