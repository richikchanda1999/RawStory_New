import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/About.dart';
import 'package:raw_story_new/BLoC/BookmarkedStories.dart';
import 'package:raw_story_new/BLoC/Home.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:raw_story_new/Styles/Home.dart';
import 'package:raw_story_new/UI/ContriPage.dart';
import '../AdSupport.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with HomeStyle {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    AdSupport().initialize(bottomNavBarHeight + 10.h);
  }

  @override
  void dispose() {
    try {
      AdSupport().dispose();
    } catch (error) {
      print(error);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
            splashColor: Colors.white,
            onPressed: () {
              ScreenBLoC().toScreen(Screens.LOGIN);
            },
            child: Transform.rotate(
              alignment: Alignment.topRight,
              angle: 270 * pi / 180,
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          )
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
        title: GestureDetector(
          onTap: () async {
            PostsBLoC().addPosts(null);
            SectionsBLoC().addSection("Latest");
            await PostsBLoC().fetchPosts(20, 0, ["hot-off-the-wires"],
                currentSectionText: "Latest");
          },
          child: Image.asset(
            'assets/Images/raw-story-logo.jpg',
            height: 130.h,
            width: 360.w,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        _scaffoldKey,
        adHeight: bottomNavBarHeight + 10.h,
      ),
      body: StreamBuilder<bool>(
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
      bottomNavigationBar: SizedBox(
        height: bottomNavBarHeight + 10.h,
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                  height: bottomNavBarHeight,
                  child: StreamBuilder<String>(
                      stream: SectionsBLoC().getSection,
                      builder: (context, snapshot) {
                        return Row(
                          children: List.generate(
                              5 * 2 - 1,
                              (index) => index % 2 == 0
                                  ? MyNavBarItem(
                                      text:
                                          SectionsBLoC.sectionTexts[index ~/ 2],
                                      icon:
                                          SectionsBLoC.sectionIcons[index ~/ 2],
                                      isSelected: snapshot.hasData
                                          ? snapshot.data ==
                                              SectionsBLoC
                                                  .sectionTexts[index ~/ 2]
                                          : index ~/ 2 == 0,
                                      scaffoldKey:
                                          index ~/ 2 == 4 ? _scaffoldKey : null,
                                    )
                                  : VerticalDivider(
                                      color: Colors.grey,
                                      width: 10.w,
                                    )),
                        );
                      })),
            ],
          ),
        ),
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
    return RefreshIndicator(
      onRefresh: () async {
        List<String> sections = PostsBLoC().currentSection;
        PostsBLoC().addPosts(null);
        await PostsBLoC().fetchPosts(20, 0, sections);
      },
      child: StreamBuilder<List<Post>>(
          stream: PostsBLoC().getPosts,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null)
              return Center(child: CircularProgressIndicator());
            String text;
            List<Post> posts = snapshot.data;
            int indx =
                SectionsBLoC.sectionURLS.indexOf(PostsBLoC().currentSection);
            indx != -1
                ? text = SectionsBLoC.sectionTexts[indx].toUpperCase()
                : text = PostsBLoC().currentSectionText.toUpperCase();
            return Container(
              // color: Colors.grey[300],
              child: Column(
                children: [
                  text.isNotEmpty
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Oswald', fontSize: 40.ssp),
                            ),
                          ))
                      : SizedBox(),
                  Expanded(
                    flex: 20,
                    child: ListView.separated(
                        padding: EdgeInsets.only(
                            top: 5.h, bottom: 40.h, left: 6.h, right: 6.h),
                        itemBuilder: (_, __) {
                          Post post = posts[__];
                          return PostCard(post, __);
                        },
                        separatorBuilder: (_, __) => __ + 1 == 5
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                height: 420.h,
                                child: AdSupport().nativeAd)
                            : Divider(
                                height: 10,
                                thickness: 0,
                              ),
                        itemCount: posts.length),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class PostCard extends StatelessWidget with PostCardStyle {
  Post post;
  int index;

  PostCard(this.post, this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          PostsBLoC.currentPost = post;
          ScreenBLoC().toScreen(Screens.POST);
        },
        child: PostCardLayouts(post).getLayout(index));
  }
}

class PostCardLayouts with PostCardStyle {
  Post post;

  PostCardLayouts(this.post);

  int getLayoutType(int index) {
    double i = ((index) % 6 + 1) / 2;

    if (i < 1.5) {
      return 0;
    } else if (i < 2.5) {
      return 1;
    } else {
      return 2;
    }
  }

  SizedBox getLayout(int index) {
    int layout = getLayoutType(index);
    List<SizedBox> layouts = [
      SizedBox(
        width: 700.w,
        height: 420.w,
        child: Container(
          margin: EdgeInsets.only(left: 9.w, right: 9.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(post.image), fit: BoxFit.fill)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black87,
                    Colors.black38,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post.headline,
                  textAlign: TextAlign.left,
                  style: postHeadlineStyle1,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        width: 700.w,
        height: 250.w,
        child: Card(
          // color: Colors.white,
          margin: EdgeInsets.only(left: 9.w, right: 9.w),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    post.headline,
                    textAlign: TextAlign.left,
                    style: postHeadlineStyle2,
                  ),
                ),
              ),
              Expanded(
                  child: Image.network(
                post.image,
                fit: BoxFit.fill,
              ))
            ],
          ),
        ),
      ),
      SizedBox(
        width: 700.w,
        height: 250.w,
        child: Card(
          margin: EdgeInsets.only(left: 9.w, right: 9.w),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              post.headline,
              textAlign: TextAlign.left,
              style: postHeadlineStyle2,
            ),
          ),
        ),
      ),
    ];
    return layouts[layout];
  }
}

class MyDrawer extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  double adHeight;

  MyDrawer(this.scaffoldKey, {this.adHeight});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();

    AdSupport().dispose();
  }

  @override
  void dispose() {
    AdSupport().initialize(widget.adHeight);

    super.dispose();
  }

  List<String> headers = [
    "Front Page",
    "Videos",
    "Commentary",
    "DC Report",
    "US News",
    "World News",
    "2020 Election",
    "Community Polls",
    "We've Got Issues Podcast",
    "Newsletter",
  ];

  List<List<String>> sections = [
    ['hot-off-the-wires'],
    ["all-video", "featured-video", "politics-video"],
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
        // color: Color(0xffe6e5ea),
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 2.ssp,
                height: 40.h,
                color: Colors.black45,
              ),
            ),
            textOption(1, context),
            textOption(2, context),
            textOption(3, context),
            textOption(4, context),
            textOption(5, context),
            textOption(6, context),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 2.ssp,
                height: 40.h,
                color: Colors.black45,
              ),
            ),
            textOption(7, context),
            textOption(8, context),
            textOption(9, context),
            Divider(
              thickness: 2.ssp,
              height: 40.h,
              color: Colors.black45,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                ScreenBLoC().toScreen(Screens.SUBSCRIPTIONS);
              },
              child: Container(
                height: 60.h,
                margin: EdgeInsets.only(left: 40.w, right: 40.w),
                color: Color(0xffdf1f27),
                child: Center(
                  child: Text(
                    'Subscribe to Raw Story'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.ssp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 80.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 60.ssp,
                        ),
                        onPressed: () {
                          AboutBLoC().init();
                          ScreenBLoC().toScreen(Screens.ABOUT);
                        }),
                    SizedBox(width: 19.ssp),
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 60.ssp,
                        ),
                        onPressed: () {
                          ScreenBLoC().toScreen(Screens.SETTINGS);
                        }),
                    SizedBox(width: 19.ssp),
                    IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          size: 60.ssp,
                        ),
                        onPressed: () {
                          BookmarkedStoriesBLoC().init();
                          ScreenBLoC().toScreen(Screens.BOOKMARKED_STORIES);
                        }),
                    SizedBox(width: 19.ssp),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 60.ssp,
                        ),
                        onPressed: () {}),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 60.ssp,
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                        }),
                  ],
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
          ScreenBLoC().toScreen(Screens.HOME);
          HomeBLoC().setTapped(false);
          PostsBLoC().addPosts(null);
          Navigator.pop(context);
          SectionsBLoC()
              .addSection(SectionsBLoC.sectionTexts[index == 0 ? 0 : 4]);
          await PostsBLoC().fetchPosts(20, 0, sections[index],
              currentSectionText: headers[index]);
        }
        if (index == 8) {
          ScreenBLoC().toScreen(Screens.PODCASTS);
        }
        if (index == 9) {
          ScreenBLoC().toScreen(Screens.NEWSLETTER);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Text(
          headers[index],
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 36.ssp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
