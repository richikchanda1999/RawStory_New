import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/About.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/UI/MyExapansionListTile.dart';
import 'package:url_launcher/url_launcher.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        children: List.generate(
          AboutBLoC().headers.length * 2,
          (index) => index % 2 == 0
              ? MyExpansionTile(
                  title: Text(
                    AboutBLoC().headers[index ~/ 2],
                    style: TextStyle(
                        fontSize: 35.ssp, fontWeight: FontWeight.w500),
                  ),
                  children: <Widget>[
                    (index~/2)!=3?Text(
                      AboutBLoC().body[index ~/ 2],
                      style: TextStyle(fontSize: 30.ssp),
                    ):GestureDetector(child: Text(
                      AboutBLoC().body[index ~/ 2],
                      style: TextStyle(fontSize: 30.ssp),
                      
                    ),
                    onTap: ()async{
                        if(await canLaunch(AboutBLoC().body[index ~/ 2]))
                        {
                          await launch(AboutBLoC().body[index ~/ 2]);
                        }
                        else{
                          print("error");
                        }
                      },
                    ),
                  ],
                )
              : Divider(
                  thickness: 5.ssp,
                  height: 40.h,
                ),
        ).toList(),
      ),
    );
  }
}
