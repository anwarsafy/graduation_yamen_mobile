import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pref_utils.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeChangeEvent>(_changeTheme);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  _changeTheme(
    ThemeChangeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await PrefUtils().setThemeData(event.themeType);
    emit(state.copyWith(themeType: event.themeType));
  }

  _onChangeLanguage(ChangeLanguage event, Emitter<ThemeState> emit) async {
    await PrefUtils().setLanguage(event.language);
    emit(state.copyWith(language: event.language));
  }


}
