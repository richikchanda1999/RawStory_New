import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:http/http.dart' as http;
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/Styles/Post.dart';
import 'package:tweet_ui/embedded_tweet_view.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void launchFB(String shareUrl) async {
  String appUrl, storeUrl;
  if (Platform.isIOS) {
    appUrl = "com.facebook.Facebook";
    storeUrl = "apps.apple.com/us/app/appname/id284882215";
  } else {
    appUrl =
        "fb://faceweb/f?href=https://www.facebook.com/sharer.php?u=$shareUrl";
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
        "http://www.twitter.com/intent/tweet?text=$shareUrl   @RawStory ";
    storeUrl =
        "https://play.google.com/store/apps/details?id=com.twitter.android";
  }
  if (await canLaunch(appUrl))
    launch(appUrl);
  else
    launch(storeUrl);
}


class NotificationWorks {
  List<NotificationModel> nmList = List<NotificationModel>();

  Future<List<NotificationModel>> getNotifications() async {
    String url = "https://www.alternet.org/feeds/send.rss";
    var resp = await http.get(url);
    var result = XmlDocument.parse(resp.body);
    var rss = result.getElement('rss');
    var channel = rss.getElement('channel');
    var item = channel.findElements('item');

    for (var i in item) {
      String title = i.getElement('title').text;
      String desc = i.getElement('description').text;
      String shareUrl = i.getElement('guid').text;
      String dateTime = i.getElement('pubDate').text.replaceFirst(" +0000","");
      String creator=i.getElement('dc:creator').text;
      nmList.add(NotificationModel(title,desc,shareUrl,dateTime,creator: creator));
    }
    // nmList.sort((a,b)=>a.dateTime.compareTo(b.dateTime));
   return nmList;
  }
}

class NotificationModel {
  NotificationModel(this.title, this.desc, this.shareUrl, this.dateTime,{this.creator});
  String title;
  String desc;
  String shareUrl;
  String dateTime;
  String creator;
}
 class PostFromNotification extends StatelessWidget with PostPageStyle {

PostFromNotification({this.notificationModel});

   NotificationModel notificationModel;

 bool chk = false;

  var txtCol = Colors.white;

  var contCol = Colors.red;

    Future<Map<String,dynamic>> getTweetDataFromId(String id) async {
    String endpoint =
        "https://api.twitter.com/1.1/statuses/show.json?id=$id";
    String bearerToken =
        "AAAAAAAAAAAAAAAAAAAAAHvkKQEAAAAArIonxGO9BNPMbq%2BlOcVR3RGBnRw%3Dsla7Lb5hv0TQekJ3PHHSB9yXcTYrudeVmLXdfsaTYaMMwnWAdQ";
    Map<String, String> headers = {"Authorization": "Bearer $bearerToken"};

    var response = await http.get(endpoint, headers: headers);

    Map<String,dynamic> result = jsonDecode(response.body);
    return result;
  }
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
                notificationModel.title,
                style: headlineStyle,
              ),

              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text(
                          "Published on ${this.notificationModel.dateTime}",
                          style: TextStyle(color: Colors.black45),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "By",
                              style: TextStyle(color: Colors.black45)),
                          TextSpan(
                              text: " ${this.notificationModel.creator}",
                              style: TextStyle(color: Colors.black))
                        ])),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        launchTwitter(this.notificationModel.shareUrl);
                      },
                      child: Container(
                        child: Image.asset(
                          "assets/Images/twitter_circle_color-512.webp",
                          height: 50.h,
                          width: 50.h,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                         launchFB(this.notificationModel.shareUrl);
                      },
                      child: Container(
                        child: Image.asset(
                          "assets/Images/6e732beb65774ba42c65fadd8c6c623a.png",
                          height: 50.h,
                          width: 50.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            
            
              Divider(
                color: Colors.white,
                thickness: 3.h,
              ),
              Html(
                data: notificationModel.desc
                    .replaceAll('<hr>', '')
                    .replaceAll('[twitter_embed', '')
                    .replaceAll('expand=1]', ''),
                customRender: {
                  "blockquote":
                      (RenderContext context, Widget child, attributes, _) {
                 String tweetId = attributes["data-twitter-tweet-id"];
                    print(tweetId);
                    if (tweetId != null)
                      return FutureBuilder<Map<String, dynamic>>(
                          future: getTweetDataFromId(tweetId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData)
                              return EmbeddedTweetView.fromTweet(
                                  Tweet.fromJson(snapshot.data));
                            else
                              return SizedBox();
                          });
                    else
                      return ConstrainedBox(
                        constraints: BoxConstraints(minWidth: width),
                        child: Html(
                          data:
                           _.innerHtml,
                            style: descriptionStyle,
                          onLinkTap: (link) async {
                            if (await canLaunch(link))
                              await launch(link);
                            else
                              print("Error");
                          },
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
              // Text(PostsBLoC.currentPost.description.replaceAll('<hr>', '')),
              SizedBox(
                height: 10.h,
              ),
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