part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ThemeChangeEvent extends ThemeEvent {
  ThemeChangeEvent({required this.themeType});

  final String themeType;

  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends ThemeEvent {
  final String language;

  ChangeLanguage({required this.language});

  @override
  List<Object?> get props => [language];
}

class FetchPopUpAds extends ThemeEvent {
  FetchPopUpAds();

  @override
  List<Object?> get props => [];
}
class FetchGeneralPopUpTimeInMinutes extends ThemeEvent {
  FetchGeneralPopUpTimeInMinutes();

  @override
  List<Object?> get props => [];
}
