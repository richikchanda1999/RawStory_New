import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/Styles/Post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tweet_webview/tweet_webview.dart';
import 'package:url_launcher/url_launcher.dart';

void launchFB() async {
  String appUrl, storeUrl;
  if (Platform.isIOS) {
    appUrl = "com.facebook.Facebook";
    storeUrl = "apps.apple.com/us/app/appname/id284882215";
  } else {
    appUrl = "facebook://xy";
    storeUrl =
        "https://play.google.com/store/apps/details?id=com.facebook.katana";
  }
  if (await canLaunch(appUrl))
    launch(appUrl);
  else
    launch(storeUrl);
}

void launchTwitter(String shareUrl) async {
  String appUrl, storeUrl;
  if (Platform.isIOS) {
    appUrl = "com.atebits.Tweetie2";
    storeUrl = "apps.apple.com/us/app/appname/id333903271";
  } else {
    appUrl =
        "http://www.twitter.com/intent/tweet?text=Check this out!\n$shareUrl\n@RawStory ";
    storeUrl =
        "https://play.google.com/store/apps/details?id=com.twitter.android";
  }
  if (await canLaunch(appUrl))
    launch(appUrl);
  else
    launch(storeUrl);
}

class PostPage extends StatelessWidget with PostPageStyle {
  bool chk = false;
  var txtCol = Colors.white;
  var contCol = Colors.red;
  String desc = PostsBLoC.currentPost.description;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
        padding: EdgeInsets.only(left: 9.w, right: 9.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                PostsBLoC.currentPost.headline,
                style: headlineStyle,
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      launchTwitter(PostsBLoC.currentPost.sourceUrl);
                    },
                    child: Container(
                      child: Image.asset(
                        "assets/Images/twitter_circle_color-512.webp",
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      launchFB();
                    },
                    child: Container(
                      child: Image.asset(
                        "assets/Images/6e732beb65774ba42c65fadd8c6c623a.jpg",
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                  height: 300.h,
                  child: Image.network(
                    PostsBLoC.currentPost.image,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Colors.white,
                thickness: 3.h,
              ),

              Html(
                data: desc
                    .replaceAll('<hr>', '')
                    .replaceAll('[twitter_embed', '')
                    .replaceAll('expand=1]', ''),
                customRender: {
                  "blockquote":
                      (RenderContext context, Widget child, attributes, _) {
                    return Container(
                      height: height * 0.5,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: SingleChildScrollView(
                        child: TweetWebView.tweetID(
                            attributes["data-twitter-tweet-id"]),
                      ),
                    );
                  },
                },
                style: descriptionStyle,
                onLinkTap: (link) async {
                  if (await canLaunch(link))
                    await launch(link);
                  else
                    print("Error");
                },
              ),
              // Text(PostsBLoC.currentPost.description
              //     .replaceAll('<hr>', '')
              //     .replaceAll('[twitter_embed', '')
              //     .replaceAll('expand=1]', '')),
              // SizedBox(
              //   height: 10.h,
              // ),
              Divider(
                color: Colors.black,
                thickness: 3.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 150.h,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Member",
                              style: TextStyle(
                                  color: txtCol,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 21),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Support Raw Story, Ad-Free, with"
                              " access to all content and special features",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: txtCol),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text("\$14.99 / month",
                              style: TextStyle(
                                  color: txtCol,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 21)),
                        ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: contCol),
                  ),
                ),
              ),
              SizedBox(
                height: 150.h,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Banner(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    color: Colors.grey,
                    location: BannerLocation.topStart,
                    message: "Save Over \$40%",
                    child: Container(
                      width: width,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Annual",
                                  style: TextStyle(
                                      color: txtCol,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 21)),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Support Raw Story, Ad-Free, with"
                              " access to all content and special features for full year",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: txtCol),
                            ),
                          )),
                          Expanded(
                              child: Align(
                            alignment: Alignment.center,
                            child: Text("\$95 for the year",
                                style: TextStyle(
                                    color: txtCol,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 21)),
                          ))
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: contCol),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150.h,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text("Supporter",
                                  style: TextStyle(
                                      color: txtCol,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 21)),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Text("Support Raw Story and go Ad-Free",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: txtCol))),
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text("\$9.99 / month",
                              style: TextStyle(
                                  color: txtCol,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 21)),
                        ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: contCol),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
