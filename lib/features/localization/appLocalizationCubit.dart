import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bevicschurch/features/settings/settingsLocalDataSource.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/uiUtils.dart';

class AppLocalizationState {
  final Locale language;
  AppLocalizationState(this.language);
}

class AppLocalizationCubit extends Cubit<AppLocalizationState> {
  final SettingsLocalDataSource settingsLocalDataSource;
  AppLocalizationCubit(this.settingsLocalDataSource) : super(AppLocalizationState(UiUtils.getLocaleFromLanguageCode(defaultLanguageCode))) {
    changeLanguage(settingsLocalDataSource.languageCode()!);
  }

  void changeLanguage(String languageCode) {
    settingsLocalDataSource.setLanguageCode(languageCode);
    emit(AppLocalizationState(UiUtils.getLocaleFromLanguageCode(languageCode)));
  }
}
