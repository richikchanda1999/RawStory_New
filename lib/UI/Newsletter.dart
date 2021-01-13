import 'package:flutter/material.dart';

import 'package:raw_story_new/BLoC/Newsletter.dart';
import 'package:raw_story_new/BLoC/Screens.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/Styles/Post.dart';

class NewsLetter extends StatefulWidget {
  @override
  _NewsLetterState createState() => _NewsLetterState();
}

class _NewsLetterState extends State<NewsLetter> with PostPageStyle {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String email;
  bool loading = false;
  Future<void> _showDialog(Size size) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thanks for signing up!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 34.ssp,
                  fontFamily: 'PTSerif')),
          content: Container(
            alignment: Alignment.center,
            height: size.height * 0.2,
            child: Text('Keep an eye on your inbox for the latest updates.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.ssp,
                    fontFamily: 'PTSerif')),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.ssp,
                      fontFamily: 'PTSerif')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
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
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        constraints: BoxConstraints(maxHeight: size.height),
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.15,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: Image.asset('assets/Images/raw-story-logo.jpg',
                  height: size.height * 0.1, width: size.width * (11 / 13)),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: size.width / 25, right: size.width / 25),
              color: Colors.white,
              constraints: BoxConstraints(maxHeight: size.height * 0.5),
              height: size.height * 0.4,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                    ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "We\'re excited you\'re here! Sign up for Raw Story\'s daily newsletter.\nSubscribe to our free newsletter!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 45.ssp,
                              fontFamily: 'Oswald'),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          // color: ,
                          onTap: () async {
                            if (email != null) {
                              setState(() {
                                loading = true;
                              });
                              int recId = (await NewsletterBloc()
                                  .fetchRecipientId(email));
                              if (recId != -1) {
                                if (await NewsletterBloc()
                                    .subscribeRecipientToList(recId)) {
                                  setState(() {
                                    loading = false;
                                  });
                                  _showDialog(size);
                                }
                                else
                                {
                                  setState(() {
                                      loading = false;
                                    });
                                }
                              } else {
                                int res = await NewsletterBloc()
                                    .createRecipient(email);
                                if (res != -1) {
                                  if (await NewsletterBloc()
                                      .subscribeRecipientToList(res)) {
                                    setState(() {
                                      loading = false;
                                    });
                                    _showDialog(size);
                                  }
                                  else{
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                }
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.4,
                            height: size.height * 0.07,
                            child: Text(
                              "Subscribe!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38.ssp,
                                  fontFamily: 'PTSerif'),
                            ),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.red,
                                  Colors.red,
                                  Colors.red[300]
                                ])),
                          ),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
