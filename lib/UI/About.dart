import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/About.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.ssp),
        children: List.generate(
            AboutBLoC().headers.length,
            (index) => Row(
                  children: <Widget>[
                    Icon(Icons.arrow_forward_ios),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      AboutBLoC().headers[index],
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 25.ssp),
                    )
                  ],
                )).toList(),
      ),
    );
  }
}
