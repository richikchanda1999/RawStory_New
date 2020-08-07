import 'package:rxdart/rxdart.dart';

enum Screens { HOME, POST, SUBSCRIPTIONS, ABOUT, SETTINGS, BOOKMARKED_STORIES, LOGIN, CONTRI }

class ScreenBLoC {
  static final ScreenBLoC _bloc = ScreenBLoC._internal();
  factory ScreenBLoC() => _bloc;

  BehaviorSubject<Screens> screenController;
  Function(Screens) get toScreen => screenController.sink.add;
  Stream<Screens> get getScreen => screenController.stream;

  ScreenBLoC._internal() {
    init();
  }

  void init() {
    if (screenController == null) {
      screenController = BehaviorSubject();
      toScreen(Screens.SUBSCRIPTIONS);
    }
  }

  void dispose() {
    if (screenController != null) screenController.close();
  }
}
