import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/support.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Design {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgCol,
      appBar: AppBar(
        backgroundColor: bgCol,
        centerTitle: true,
        title: Text(
          'LOGIN',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: buttonCol),
        ),
      ),
      body: Stack(
        children: <Widget>[
          placementWidget(
            height: 60,
            width: 206,
            start: 85,
            top: 80,
            child: Image.asset(
              'assets/Images/raw-story-logo.jpg',
              alignment: Alignment.center,
              height: 60,
              width: 190,
            ),
          ),
          placementWidget(
            start: 19,
            top: 225,
            width: 337,
            height: 129,
            child: Form(
                child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: cardTxtCol,borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: 'Enter your Email',border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: cardTxtCol,borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration:
                          InputDecoration(hintText: 'Enter your Password',border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            )),
          ),
          placementWidget(
            height: 40,
            width: 120,
            start: 128,
            top: 381,
            child: RaisedButton(
              onPressed: () {},
              color: buttonCol,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: cardTxtCol,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
