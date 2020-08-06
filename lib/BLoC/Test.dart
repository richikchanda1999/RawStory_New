import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raw_story_new/Models/Post.dart';

class Test {
  Future<void> test() async {
    String url =
        "https://$username:$password@rawstory.rebelmouse.com/api/1.3/posts?limit=10";

    Map<String, String> temp = params.cast();
    temp['from_sections_other_than'] = 'news';
    var req = await http.get(url, headers: temp);

    List<Post> posts = List();
    if (req.statusCode == 200) {
      var list = json.decode(req.body);
      for (Map<String, dynamic> item in list) posts.add(Post.fromMap(item));
    }

    Map<int, String> sectionNames = Map();
    String sURL =
        "https://$username:$password@rawstory.rebelmouse.com/api/1.3/sections/";
    for (Post post in posts) {
      List<String> sections = List();
      for (int section in post.sections) {
        if (!sectionNames.containsKey(section)) {
          var req = await http.get(sURL + section.toString(), headers: params);
          if (req.statusCode == 200) {
            var list = json.decode(req.body);
            sectionNames[section] = section.toString() + '-' + list['title'];
            sections.add(sectionNames[section]);
          }
        } else
          sections.add(sectionNames[section]);
      }
      print(post.headline + "\t$sections");
    }
  }
}

var username = 'raw';
var password = 'story';
String key = "Gl7Zt29tYHGHhqGDuRV01NK8pq5UCDdht2EFwOfIGeDqv2oG80TXH006IAhG43z6";
var params = {'Content-Type': 'application/json', 'X-RMAuth': key};
