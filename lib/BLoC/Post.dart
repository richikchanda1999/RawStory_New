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

  List<Post> currentPosts = List<Post>();
  static Post currentPost;
  List<String> currentSection;
  String currentSectionText;

  Future<void> init() async {
    postController = BehaviorSubject();
  }

  double scrollOffset = 0.0;
  int postCount = 20;
  void setOffset(double offset) {
    scrollOffset = offset;
  }

  void setPostCount(int c) {
    postCount = c;
  }

  Future<void> fetchPosts(int limit, int offset, List<String> sections,
      {String currentSectionText}) async {
    setOffset(0.0);
    setPostCount(20);
    currentPosts = List<Post>();
    currentSection = sections;
    this.currentSectionText = currentSectionText;
    for (String sectionName in sections) {
      List<Post> temp = await Worker.work(
          limit: limit, offset: offset, sectionName: sectionName);
      currentPosts.addAll(temp);
    }
    addPosts(currentPosts);
  }

  Future<void> fetchExtraPost(
      int limit, int offset, List<String> sections) async {
    for (String sectionName in sections) {
      List<Post> temp = await Worker.work(
          limit: limit, offset: offset, sectionName: sectionName);
      currentPosts.addAll(temp);
    }

    addPosts(currentPosts);
  }

  void dispose() {
    if (postController != null) postController.close();
  }
}
