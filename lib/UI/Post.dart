import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/Styles/Post.dart';
import '../Models/Post.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPage extends StatelessWidget with PostPageStyle {
  var txtCol = Colors.white;
  var contCol = Colors.red;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
              SizedBox(
                  height: 300.h,
                  child: Image.network(
                    PostsBLoC.currentPost.image,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 20.h,
              ),
              Text(
                PostsBLoC.currentPost.headline,
                style: headlineStyle,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 20.h,
              ),
              Divider(
                color: Colors.white,
                thickness: 3.h,
              ),
              Html(
                data: PostsBLoC.currentPost.description,
                style: descriptionStyle,
              ),
              Divider(
                color: Colors.white,
                thickness: 3.h,
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
                              style: TextStyle(color: txtCol)),
                        )),
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
                        borderRadius: BorderRadius.circular(20), color: contCol),
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
                        borderRadius: BorderRadius.circular(20), color: contCol),
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
                              padding: const EdgeInsets.only(left: 20, right: 20),
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
                        borderRadius: BorderRadius.circular(20), color: contCol),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
      ),
    );
  }
}
