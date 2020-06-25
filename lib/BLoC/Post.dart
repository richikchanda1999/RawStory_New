import 'package:raw_story_new/BLoC/Worker.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:rxdart/rxdart.dart';

class PostsBLoC {
  static final PostsBLoC _bloc = PostsBLoC._internal();
  factory PostsBLoC() => _bloc;

  BehaviorSubject<List<Post>> postController;
  Function(List<Post>) get addPosts => postController.sink.add;
  Stream<List<Post>> get getPosts => postController.stream;
  List<Post> posts;
  int limit, offset;
  String sectionName;

  static Post currentPost;

  PostsBLoC._internal() {
    Worker();
    init();
  }

  Future<void> init() async {
    if (postController == null) postController = BehaviorSubject();

    if (posts == null) {
      limit = 30;
      offset = 0;
      sectionName = "big-stories";
      posts = await Worker.work(limit: limit, offset: offset, sectionName: sectionName);
      for(Post p in posts) print(p.sections);
      addPosts(posts);
    }
  }

  void dispose() {
    if (postController != null) postController.close();
  }
}