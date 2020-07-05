
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
  static const List<List<String>> sectionURLS = [
    ["latest-headlines"],
    ["covid-19", "elections", "2020-election"],
    ["featured"],
    ["all-video", "featured-video", "politics-video"],
    ["big-stories", "world"]
  ];
}

var username = 'raw';
var password = 'story';
String key = "Gl7Zt29tYHGHhqGDuRV01NK8pq5UCDdht2EFwOfIGeDqv2oG80TXH006IAhG43z6";
var params = {'Content-Type': 'application/json', 'X-RMAuth': key};
