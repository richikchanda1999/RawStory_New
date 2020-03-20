import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:raw_story_new/SinglePost.dart';
import 'package:raw_story_new/support.dart';

class WordPressClass with Design
{
  wp.WordPress wordPress=wp.WordPress(
      baseUrl: 'https://zoxannedev.wpengine.com'
  );
  Future<List<wp.Post>> fetchPosts() {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
        postParams: wp.ParamsPostList(),
        fetchAuthor: true,
        fetchFeaturedMedia: true
    );

    return posts;
  }

  Widget _buildFeaturedMedia(wp.Media featuredMedia) {
    if (featuredMedia == null) {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
    String imgSource = featuredMedia.mediaDetails.sizes.mediumLarge.sourceUrl;
    return Image.network(
      imgSource,
      fit: BoxFit.fitWidth,
    );
  }

  Widget buildPostCard({
    String author,
    String title,
    String content,
    wp.Media featuredMedia,
  }) {
    return Card(
      color: cardCol,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildFeaturedMedia(featuredMedia),
          featuredMedia == null
              ? Divider()
              : SizedBox(
            width: 0,
            height: 0,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color:cardTxtCol),
            ),
          ),
        ],
      ),
    );
  }
  void openPostPage(BuildContext context,wp.Post post) {
    print('OnTapped');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return SinglePostPage(wordPress: wordPress, post: post,);
      }),
    );
  }
}
