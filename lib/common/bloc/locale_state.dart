part of 'locale_cubit.dart';

abstract class LocaleState {
  final String languageCode; // 'en' or 'si'
  const LocaleState(this.languageCode);

  bool get isSinhala => languageCode == 'si';
  Locale get locale => Locale(languageCode);
}

class LocaleInitial extends LocaleState {
  const LocaleInitial(super.languageCode);
}
