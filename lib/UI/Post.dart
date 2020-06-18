import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/Styles/Post.dart';
import '../Models/Post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPage extends StatelessWidget with PostPageStyle{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              ScreenBLoC().toScreen(Screens.HOME);
            }),
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: true,
      body: Padding(
        padding: EdgeInsets.only(left: 34.w, right: 34.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 300.h, child: Image.network(PostsBLoC.currentPost.image, fit: BoxFit.fill,)),
              SizedBox(height: 20.h,),
              Text(PostsBLoC.currentPost.headline, style: headlineStyle, textAlign: TextAlign.justify,),
              SizedBox(height: 20.h,),
              Divider(color: Colors.white, thickness: 3.h,),
              Html(data: PostsBLoC.currentPost.description, style: descriptionStyle,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(height: 100,),
    );
  }
}
