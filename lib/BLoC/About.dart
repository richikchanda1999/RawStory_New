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
      'Terms Of Use / Privacy Policy',
    ];

    body = [
      'The Raw Story is an American online tabloid founded in 2004 by John K. Byrne. It covers current national and international political events and publishes its own editorials which tend to advocate for progressive positions. The Raw Story is a news site, bringing attention to stories that it sees as downplayed or ignored by other media outlets. It is owned by Raw Story Media, Inc.',
      "Raw Story FAQ",
      "EDITOR & PUBLISHER\n"
"Roxanne Cooper Bio | Email | Twitter\n\n"
"MANAGING EDITOR\n"
"Eric W. Dolan Bio | Email | Archive | Twitter\n\n"
"ASSISTANT TO THE PUBLISHER\n"
"David McBrayer Bio | Email\n\n"
"SENIOR EDITORS\n"
"David Edwards Bio | Email | Archive | Twitter\n"
"Travis Gettys Bio | Email | Archive | Twitter\n"
"Bob Brigham Email\n"
"Tana Ganeva Bio | Email\n"
"Sarah Burris Bio | Email\n"
"Tom Boggioni Bio |Email | Twitter\n\n"
"NEWS WRITERS\n"
"Matthew Chapman Bio\n"
"Dominque Jackson Bio | Email\n"
"Brad Reed Bio | Email\n\n"
"WEB DEVELOPER\n"
"Ben Nguyen Bio\n\n"
"MEMBERSHIP COORDINATOR\n"
"Elias Cunningham | Bio | Email\n"
"Raw Story Media, Inc.\n\n"
"FOUNDER, CHAIRMAN & CEO\n"
"John Byrne Bio\n\n"
"VICE CHAIRMAN\n"
"Michael Rogers Bio\n\n"
"CHIEF REVENUE OFFICER\n"
"Jamel Giuma | Email\n\n"
"WIRE SERVICES\n"
"Agence France-Presse (AFP)\n\n"
"CONTACT INFORMATION\n"
"Raw Story Media, Inc.\n"
"PO Box 21050\n"
"Washington, D.C. 20009\n"
"Facebook | Twitter | Google+ | Tumblr\n"
"For copyright information and concerns, please email Roxanne Cooper or call her at 202.538.0274.",
      'https://www.rawstory.com/privacy-policy/'
    ];
  }
}
