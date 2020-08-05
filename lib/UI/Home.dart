import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:raw_story_new/Styles/Home.dart';
import 'package:raw_story_new/UI/ContriPage.dart';

import '../AdSupport.dart';
import 'Login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with HomeStyle {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: AdSupport().getAppId()).then((_) {
      myBanner
        ..load()
        ..show();
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton.icon(
              splashColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'User Login',
                style: TextStyle(color: Colors.white),
              ))
        ],
        leading: IconButton(
            icon: Icon(
              Icons.monetization_on,
              color: tapped ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                tapped = !tapped;
              });
            }),
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: AnimatedSwitcher(
           transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation,);
                  },
          child: homeSubWrapper(tapped),
          duration: Duration(milliseconds: 400),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: bottomNavBarHeight + 60 + 10.h,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
                height: bottomNavBarHeight,
                child: StreamBuilder<String>(
                    stream: SectionsBLoC().getSection,
                    builder: (context, snapshot) {
                      return Row(
                        children: List.generate(
                            5,
                            (index) => MyNavBarItem(
                                text: SectionsBLoC.sectionTexts[index],
                                icon: SectionsBLoC.sectionIcons[index],
                                isSelected: snapshot.hasData
                                    ? snapshot.data ==
                                        SectionsBLoC.sectionTexts[index]
                                    : index == 0)),
                      );
                    })),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
      ),
    );
  }
}

Widget homeSubWrapper(bool tapped) {
  return (tapped ? ContributionPage() : PostsList());
}

class MyNavBarItem extends StatelessWidget {
  IconData icon;
  String text;
  bool isSelected;

  MyNavBarItem(
      {@required this.text, @required this.icon, @required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          PostsBLoC().addPosts(null);
          SectionsBLoC().addSection(text);
          List<String> sections =
              SectionsBLoC.sectionURLS[SectionsBLoC.sectionTexts.indexOf(text)];
          await PostsBLoC().fetchPosts(30, 0, sections);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: isSelected ? Colors.red : Colors.white),
            Text(
              text,
              style: TextStyle(color: isSelected ? Colors.red : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
        stream: PostsBLoC().getPosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null)
            return CircularProgressIndicator();
          List<Post> posts = snapshot.data;
          return ListView.separated(
              padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
              itemBuilder: (_, __) {
                Post post = posts[__];
                return PostCard(post);
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: posts.length);
        });
  }
}

class PostCard extends StatelessWidget with PostCardStyle {
  Post post;

  PostCard(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PostsBLoC.currentPost = post;
        ScreenBLoC().toScreen(Screens.POST);
      },
      child: SizedBox(
        width: 700.w,
        height: 400.w,
        child: Container(
          margin: EdgeInsets.only(left: 30.w, right: 30.w),
          padding: EdgeInsets.all(20.ssp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.ssp),
              image: DecorationImage(
                  image: NetworkImage(post.image), fit: BoxFit.fill)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              post.headline,
              textAlign: TextAlign.justify,
              style: postHeadlineStyle,
            ),
          ),
        ),
      ),
    );
  }
}
