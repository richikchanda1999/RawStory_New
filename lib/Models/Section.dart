class Section {
  int id, createdTS, parentID, type;
  String title, url, fullUrl, domain;
  int status; //1 - Private, 2 - Public, 3 - Unlisted
  List<String> tags;
  String aboutHtml;

  Section.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    createdTS = map['created_ts'];
    parentID = map['parent_id'];
    type = map['type'];

    title = map['title'];
    url = map['url'];
    fullUrl = map['full_url'];
    domain = map['domain'];

    status = map['status'];

    var temp = map['tags'];
    if (temp is List<dynamic>)
      tags = temp.map((e) => e as String).toList();

    aboutHtml = map['about_html'];
  }

  List<String> types = ["Private", "Public", "Unlisted"];
  String toString() => url;
//  String toString() => "ID : $id, Title: $title, Type: ${types[type]}, URL: $url, Full URL: $fullUrl, Domain: $domain\nAbout HTML: $aboutHtml";
}
