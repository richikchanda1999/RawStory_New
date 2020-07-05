class Post {
  int id, insertedTS, updatedTS;
  String headline, description, image, sourceUrl;
  String insertedDate;

  List<int> sections;

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    headline = map['headline'];
    description = map['description'];
    image = map['image'];
    insertedDate = map['inserted_date'];
    insertedTS = map['inserted_ts'];
    updatedTS = map['updated_ts'];
    sourceUrl = map['source_url'];

    var sectionD = map['sections'];
    if (sectionD is List<dynamic>)
      sections = sectionD.map((e) => e as int).toList();
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
        sections
      ];

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) {
    return id == other.id;
  }
}
