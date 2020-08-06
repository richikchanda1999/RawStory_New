import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Home.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:raw_story_new/Styles/Home.dart';
import 'package:raw_story_new/UI/ContriPage.dart';

import '../AdSupport.dart';
import 'Login.dart';

class Home extends StatelessWidget with HomeStyle {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: AdSupport().getAppId()).then((_) {
      myBanner
        ..load()
        ..show();
    });

    return Scaffold(
      key: _scaffoldKey,
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
        leading: StreamBuilder<bool>(
            initialData: false,
            stream: HomeBLoC().getTappedState,
            builder: (context, snapshot) {
              return IconButton(
                  icon: Icon(
                    Icons.monetization_on,
                    color: snapshot.data ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    HomeBLoC().setTapped(!snapshot.data);
                  });
            }),
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(_scaffoldKey),
      body: Center(
        child: StreamBuilder<bool>(
            initialData: false,
            stream: HomeBLoC().getTappedState,
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    child: child,
                    scale: animation,
                  );
                },
                child: snapshot.data ? ContributionPage() : PostsList(),
                duration: Duration(milliseconds: 400),
              );
            }),
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
                                      : index == 0,
                                  scaffoldKey: index == 4 ? _scaffoldKey : null,
                                )),
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

class MyNavBarItem extends StatelessWidget {
  IconData icon;
  String text;
  bool isSelected;
  GlobalKey<ScaffoldState> scaffoldKey;

  MyNavBarItem(
      {@required this.text,
      @required this.icon,
      @required this.isSelected,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          int index = SectionsBLoC.sectionTexts.indexOf(text);
          if (index <= 3) {
            PostsBLoC().addPosts(null);
            SectionsBLoC().addSection(text);
            List<String> sections = SectionsBLoC.sectionURLS[index];
            await PostsBLoC().fetchPosts(20, 0, sections);
          } else if (index == 4) {
            if (scaffoldKey != null) {
              scaffoldKey.currentState.openDrawer();
            }
          }
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

class MyDrawer extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  MyDrawer(this.scaffoldKey);

  List<String> headers = [
    "Latest News",
    "Commentary",
    "DC Report",
    "US News",
    "World News",
    "2020 Election",
    "Community Polls",
    "We've Got Issues Podcast",
    "Newsletter",
    "Shop"
  ];

  List<List<String>> sections = [
    ['latest-headlines'],
    ['commentary'],
    ['dc-report'],
    ['us-news'],
    ['world'],
    ['2020-election', 'elections'],
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xffe6e5ea),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 140.h,
              child: DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Images/raw-story-logo.jpg',
                      height: 100.h,
                      width: 300.w,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            textOption(0, context),
            Divider(),
            textOption(1, context),
            textOption(2, context),
            textOption(3, context),
            textOption(4, context),
            textOption(5, context),
            Divider(),
            textOption(6, context),
            textOption(7, context),
            textOption(8, context),
            textOption(9, context),
            Divider(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                ScreenBLoC().toScreen(Screens.SUBS);
              },
              child: Container(
                height: 60.h,
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                color: Color(0xffff2722),
                child: Center(
                  child: Text(
                    'Subscribe to Raw Story',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 25.ssp),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textOption(int index, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (index < sections.length) {
          ScreenBLoC().toScreen(Screens.POST);
          HomeBLoC().setTapped(false);
          PostsBLoC().addPosts(null);
          Navigator.pop(context);
          SectionsBLoC().addSection(SectionsBLoC.sectionTexts[4]);
          await PostsBLoC().fetchPosts(20, 0, sections[index]);
        }
      },
      child: Text(
        headers[index],
        style: TextStyle(fontFamily: 'Roboto', fontSize: 25.ssp),
      ),
    );
}
