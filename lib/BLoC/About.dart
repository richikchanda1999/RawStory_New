import 'package:rxdart/rxdart.dart';

class AboutBLoC {
  static final AboutBLoC _bloc = AboutBLoC._internal();
  factory AboutBLoC() => _bloc;
  AboutBLoC._internal();

  BehaviorSubject<List<int>> _indexController;
  Function(List<int>) get addIndex => _indexController.sink.add;
  Stream<List<int>> get getIndex => _indexController.stream;
  List<int> get index => _indexController.value;

  List<String> headers;
  List<String> body;

  void init() {
    _indexController = BehaviorSubject();

    headers = [
      'About Raw Story',
      'Raw Story FAQ',
      'Masthead',
      'Terms Of Use',
      'Privacy Policy'
    ];

    headers = [
      'About Raw Story',
      'Raw Story FAQ',
      'Masthead',
      'Terms Of Use',
      'Privacy Policy'
    ];
  }

  Future<void> dispose() async {
    await _indexController.close();
  }
}
