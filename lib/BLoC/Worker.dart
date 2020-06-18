import 'dart:async';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:isolate_handler/isolate_handler.dart';
import 'dart:convert';

import 'package:raw_story_new/Models/Post.dart';

var username = 'raw';
var password = 'story';
String key = "Gl7Zt29tYHGHhqGDuRV01NK8pq5UCDdht2EFwOfIGeDqv2oG80TXH006IAhG43z6";
var params = {'Content-Type': 'application/json', 'X-RMAuth': key};

class Worker {
  static final Worker _worker = Worker._internal();
  factory Worker() => _worker;

  static IsolateHandler _isolateHandler;
  static String isolateName = "get_posts";
  static Completer<bool> _isIsolateSpawned;
  static Completer<bool> _isIsolateComplete;
  static List<Post> posts;

  Worker._internal() {
    _isolateHandler = IsolateHandler();
  }

  static Future<List<Post>> work({int limit, int offset}) async {
    _isIsolateSpawned = Completer();
    _isIsolateComplete = Completer();
    spawn();
    await _isIsolateSpawned.future;
    _isolateHandler.send([limit, offset], to: isolateName);
    await _isIsolateComplete.future;
    return posts;
  }

  static void spawn() {
    _isolateHandler.spawn(isolateEntry,
        name: isolateName,
        onReceive: postsReceived,
        onInitialized: onInitialised);
  }

  static Future<List<Post>> getPosts({int limit, int offset}) async {
    String url =
        "https://$username:$password@rawstory.rebelmouse.com/api/1.3/posts/frontpage?limit=${limit ?? 10}&offset=${offset ?? 0}";
    var req = await http.get(url, headers: params);

    List<Post> posts = List();
    if (req.statusCode == 200) {
      var list = json.decode(req.body);
      for (Map<String, dynamic> item in list) posts.add(Post.fromMap(item));
    }
    return posts;
  }

  static void isolateEntry(Map<String, dynamic> context) {
    final messenger = HandledIsolate.initialize(context);
    messenger.listen((message) async {
      if (message is List<dynamic>) {
        List<Post> posts = await getPosts(limit: message[0], offset: message[1]);
        messenger.send(posts.map((e) => e.toList()).toList());
      }
    });
  }

  static void postsReceived(dynamic message) {
    if (message is List<List<dynamic>>) {
      posts = message.map((e) => Post.fromList(e)).toList();
      _isIsolateComplete.complete(true);
    }
  }

  static void onInitialised() {
    _isIsolateSpawned.complete(true);
  }

  static void dispose() {
    _isolateHandler.kill(isolateName);
  }
}
