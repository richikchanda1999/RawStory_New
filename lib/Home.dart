
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:raw_story_new/AdSupport.dart';
import 'package:raw_story_new/Login.dart';
import 'package:raw_story_new/WordPressIntegration.dart';
import 'package:raw_story_new/support.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Design {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WordPressClass().fetchPosts();
  }

  @override
  void dispose() {

    super.dispose();
  }

  int index;

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: AdSupport().getAppId()).then((_){
      myBanner..load()..show();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: index == -1
            ? FlatButton(
                splashColor: Colors.white,
                color: Color.fromRGBO(241, 16, 33, 1),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () async {},
              )
            : SizedBox(),
        actions: <Widget>[
          FlatButton.icon(
              splashColor: buttonCol,
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
                color: cardTxtCol,
              ),
              label: Text(
                'User Login',
                style: TextStyle(color: cardTxtCol),
              ))
        ],
        title: Align(
          alignment: AlignmentDirectional(-0.3, 0.0),
          child: Image.asset(
            'assets/Images/raw-story-logo.jpg',
            height: 90,
            width: 190,
          ),
        ),
      ),
      body: FutureBuilder<List<wp.Post>>(
        future: WordPressClass().fetchPosts(),
        builder: (context, snap) {
          return snap.hasData
              ? ListView.builder(
                  itemBuilder: (context, i) {
                    String title = snap.data[i].title.rendered;
                    String author = snap.data[i].author.name;
                    String content = snap.data[i].content.rendered;
                    wp.Media featuredMedia = snap.data[i].featuredMedia;

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          WordPressClass().openPostPage(context, snap.data[i]);
                        },
                        child: WordPressClass().buildPostCard(
                          author: author,
                          title: title,
                          content: content,
                          featuredMedia: featuredMedia,
                        ),
                      ),
                    );
                  },
                  itemCount: snap.data.length,
                )
              : SpinKitChasingDots(
                  color: Colors.red,
                  size: 50,
                );
        },
      ),

    );
  }
}
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['games', 'pubg'],
  contentUrl: 'https://flutter.io',
  // ignore: deprecated_member_use
  birthday: DateTime.now(),
  childDirected: false,
  // ignore: deprecated_member_use
  designedForFamilies: false,
  // ignore: deprecated_member_use
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);