class Post {
  int id, insertedTS, updatedTS;
  String headline, description, image, sourceUrl;
  String insertedDate;

  Post(
      {this.id,
      this.headline,
      this.description,
      this.image,
      this.insertedDate,
      this.insertedTS,
      this.updatedTS,
      this.sourceUrl,});

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    headline = map['headline'];
    description = map['description'];
    image = map['image'];
    insertedDate = map['inserted_date'];
    insertedTS = map['inserted_ts'];
    updatedTS = map['updated_ts'];
    sourceUrl = map['source_url'];
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
  }

  List<dynamic> toList() => [
        id,
        headline,
        description,
        image,
        insertedDate,
        insertedTS,
        updatedTS,
        sourceUrl
      ];
}
