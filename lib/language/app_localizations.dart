import 'package:flutter/material.dart';
import '../models/language_data_model.dart';
import 'base_language.dart';
import 'language_af.dart';
import 'language_ar.dart';
import 'language_en.dart';
import 'language_fr.dart';
import 'language_hi.dart';
import 'language_pt.dart';
import 'language_tr.dart';
import 'language_vi.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return LanguageAr();
      case 'en':
        return LanguageEn();
      case 'fr':
        return LanguageFr();

      default:
        return LanguageAr();
    }
  }

  // @override
  // bool isSupported(Locale locale) =>
  //     LanguageDataModel.languages().contains(locale.languageCode);
  @override
  bool isSupported(Locale locale) => [
        'ar',
        'en',
        'fr',
      ].contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
