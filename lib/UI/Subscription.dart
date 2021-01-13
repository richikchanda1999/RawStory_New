import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Screens.dart';

class SubsPage extends StatelessWidget {


  var txtCol = Colors.white;
  var contCol = Colors.red;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/Images/raw-story-logo.jpg',
          height: 130.h,
          width: 360.w,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text("Join Raw Story today",
                        style: TextStyle(
                            color: txtCol,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.cancel,
                        color: txtCol,
                      ),
                      onPressed: () {
                        ScreenBLoC().toScreen(Screens.HOME);
                      },
                    ))
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Progressive journalism matters to you, and we know that ads get in the way,so become a member / supporter"
                  " of RawStory to see clearer picture.\n\n\nWe believe facts are sacred. Become part of a movement with us."
                  " Power progressive journalism.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: txtCol, fontSize: 15),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Join today, and your first month is only \$1",
                    style: TextStyle(
                        color: txtCol,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Banner(
                  location: BannerLocation.topStart,
                  textStyle: TextStyle(
                    
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                  color: Colors.grey,
                  
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
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
              )),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
