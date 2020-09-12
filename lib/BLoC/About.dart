class AboutBLoC {
  static final AboutBLoC _bloc = AboutBLoC._internal();
  factory AboutBLoC() => _bloc;
  AboutBLoC._internal();

  List<String> headers;
  List<String> body;

  void init() {
    headers = [
      'About Raw Story',
      'Raw Story FAQ',
      'Masthead',
      'Terms Of Use',
      'Privacy Policy'
    ];

    body = [
      'About Raw Story',
      'Raw Story FAQ',
      'Masthead',
      'Terms Of Use',
      'Privacy Policy'
    ];
  }
}
