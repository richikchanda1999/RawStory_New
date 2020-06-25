import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raw_story_new/Models/Section.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class SectionsBLoC {
  static final SectionsBLoC _bloc = SectionsBLoC._internal();
  factory SectionsBLoC() => _bloc;
  SectionsBLoC._internal();

  BehaviorSubject<String> sectionsController;
  Function(String) get addSection => sectionsController.sink.add;
  Stream<String> get getSection => sectionsController.stream;

  void init() {
    sectionsController = BehaviorSubject<String>();
  }

  void dispose() {
    if (sectionsController != null) sectionsController.close();
  }

  Future<void> fetchSections() async {
    String url =
        "https://$username:$password@rawstory.rebelmouse.com/api/1.3/sections";
    var req = await http.get(url, headers: params);

    print(req.statusCode);
    if (req.statusCode == 200) {
      List<dynamic> sectionsList = json.decode(req.body);
      print("Total sections: ${sectionsList.length}");
      for(var sectionMap in sectionsList) {
        Section section = Section.fromMap(sectionMap);
        print(section);
      }
    }
  }

  static const List<String> sectionTexts = [
    "Latest",
    "Trending",
    "Exclusives",
    "Video",
    "Content"
  ];
  static const List<IconData> sectionIcons = [
    Icons.whatshot,
    Icons.trending_up,
    Icons.receipt,
    Icons.video_library,
    Icons.view_headline
  ];
}

var username = 'raw';
var password = 'story';
String key = "Gl7Zt29tYHGHhqGDuRV01NK8pq5UCDdht2EFwOfIGeDqv2oG80TXH006IAhG43z6";
var params = {'Content-Type': 'application/json', 'X-RMAuth': key};