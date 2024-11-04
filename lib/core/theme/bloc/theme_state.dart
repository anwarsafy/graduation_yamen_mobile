part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.themeType = 'lightMode',
    this.language,
    // this.notificationPopupList = const [],
  });

  final String themeType;
  final String? language;

  // final List<NotificationPopupModel> notificationPopupList;

  @override
  List<Object?> get props => [
        language,
        themeType,
        // notificationPopupList,
      ];

  ThemeState copyWith({
    String? themeType,
    String? language,
    // List<NotificationPopupModel>? notificationPopupList,
  }) {
    return ThemeState(
      themeType: themeType ?? this.themeType,
      language: language ?? this.language,
      // notificationPopupList:
      //     notificationPopupList ?? this.notificationPopupList,
    );
  }
}
