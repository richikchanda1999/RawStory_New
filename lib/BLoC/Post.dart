import 'package:raw_story_new/BLoC/Worker.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:rxdart/rxdart.dart';

class PostsBLoC {
  static final PostsBLoC _bloc = PostsBLoC._internal();
  factory PostsBLoC() => _bloc;
  PostsBLoC._internal();

  BehaviorSubject<List<Post>> postController;
  Function(List<Post>) get addPosts => postController.sink.add;
  Stream<List<Post>> get getPosts => postController.stream;

  static Post currentPost;

  Future<void> init() async {
    postController = BehaviorSubject();
  }

  Future<void> fetchPosts(int limit, int offset, List<String> sections) async {
    List<Post> posts = List();
    for (String sectionName in sections) {
      List<Post> temp = await Worker.work(
          limit: limit, offset: offset, sectionName: sectionName);
      posts.addAll(temp);
    }
    posts = posts.toSet().toList();
    posts.shuffle();
    addPosts(posts);
  }

  void dispose() {
    if (postController != null) postController.close();
  }
}
