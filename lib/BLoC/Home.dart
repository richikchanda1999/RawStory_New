import 'package:rxdart/rxdart.dart';

class HomeBLoC {
  static final HomeBLoC _bloc = HomeBLoC._internal();
  factory HomeBLoC() => _bloc;
  HomeBLoC._internal();

  BehaviorSubject<bool> _tapController;
  Function(bool) get setTapped => _tapController.sink.add;
  Stream<bool> get getTappedState => _tapController.stream;
  bool get tapped => _tapController.value;

  void init() {
    _tapController = BehaviorSubject();
  }

  Future<void> dispose() async {
    await _tapController.close();
  }
}