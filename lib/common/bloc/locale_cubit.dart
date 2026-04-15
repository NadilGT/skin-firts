import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleInitial('en')) {
    _loadLocale();
  }

  static const String _localeKey = 'appLanguageCode';

  /// Toggle between English and Sinhala.
  void toggleLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final newCode = state.isSinhala ? 'en' : 'si';
    await prefs.setString(_localeKey, newCode);
    emit(LocaleInitial(newCode));
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? 'en';
    emit(LocaleInitial(code));
  }
}
