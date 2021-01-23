class Post {
  int id, insertedTS, updatedTS;
  String headline, description, image, sourceUrl;
  String insertedDate;

  String rawShareUrl;
  String authorName = '';
  List<int> sections;

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    headline = map['headline'];
    description = map['description'];
    image = map['image'] ?? null;
    insertedDate = map['inserted_date'];
    insertedTS = map['inserted_ts'];
    updatedTS = map['updated_ts'];
    sourceUrl = map['source_url'];

    var sectionD = map['sections'];
    if (sectionD is List<dynamic>)
      sections = sectionD.map((e) => e as int).toList();

    for (var r in map['roar_authors']) {
      if (authorName == '')
        authorName = r['title'];
      else
        authorName = authorName + ', ' + r['title'];
    }

    rawShareUrl = map['raw_share_url'];
  }

  Post.fromList(List<dynamic> list) {
    id = list[0];
    headline = list[1];
    description = list[2];
    image = list[3];
    insertedDate = list[4];
    insertedTS = list[5];
    updatedTS = list[6];
    sourceUrl = list[7];
    sections = list[8];
    authorName = list[9];
    rawShareUrl = list[10];
  }

  List<dynamic> toList() => [
        id,
        headline,
        description,
        image,
        insertedDate,
        insertedTS,
        updatedTS,
        sourceUrl,
        sections,
        authorName,
        rawShareUrl
      ];

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) {
    return id == other.id;
  }
}
