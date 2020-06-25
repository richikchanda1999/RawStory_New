import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Models/Post.dart';
import 'package:raw_story_new/Styles/Home.dart';

import '../AdSupport.dart';
import 'Login.dart';

class Home extends StatelessWidget with HomeStyle{
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
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: PostsList(),
      ),
      bottomNavigationBar: SizedBox(
        height: bottomNavBarHeight + 60 + 10.h,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.h,),
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
                                    ? snapshot.data == SectionsBLoC.sectionTexts[index]
                                    : index == 0)),
                      );
                    })),
            SizedBox(height: 60,)
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

  MyNavBarItem(
      {@required this.text, @required this.icon, @required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          SectionsBLoC().addSection(text);
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
          if (!snapshot.hasData) return CircularProgressIndicator();
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
        height: 500.w,
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

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['news'],
  contentUrl: 'https://flutter.io',
  // ignore: deprecated_member_use
  birthday: DateTime.now(),
  childDirected: false,
  // ignore: deprecated_member_use
  designedForFamilies: false,
  // ignore: deprecated_member_use
  gender:
      MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.banner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
