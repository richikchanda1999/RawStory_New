class BookmarkedStoriesBLoC {
  static final BookmarkedStoriesBLoC _bloc = BookmarkedStoriesBLoC._internal();
  factory BookmarkedStoriesBLoC() => _bloc;
  BookmarkedStoriesBLoC._internal();

  List<String> headings;
  List<String> dates;

  void init() {
    headings = [
      "This domestic terrorism expert tried to warn us about right-wing extremism - he lost his job because of it",
      "Donald Trump\'s week from hell",
      "Evangelicals revolt against Trump as he rants spiral into increased profanity: 'I might just stay home this time'",
      "Trump's Eipstein conspiracy proves he's now mentally 'unbalanced'",
      "Prosecutors' ridiculous excuses for excluding black people from juries",
      "Will Trump supporters ever open their eyes to see what's right in front of them?",
      "Top NBC reporter brazenly denies Trump prefers white immigrantsL 'I'm not sure where you're getting that'",
      "Trump spreading conspiracy theory suggesting Bill Clinton murdered Jeffrey Eipstein"
    ];
    dates = [
      "August 12, 2019",
      "August 9, 2019",
      "August 7, 2019",
      "August 8, 2019",
      "August 4, 2019",
      "August 5, 2019",
      "July 28, 2019",
      "July 23, 2019"
    ];
  }
}
