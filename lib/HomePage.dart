import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Completer<WebViewController>();
  int currentIndex = 0;
  int index;
  var c;
  String currentUrl;
  List<String> url = [
    'https://zoxannedev.wpengine.com/app-latest/?app_template=true',
    'https://zoxannedev.wpengine.com/app-trending/?app_template=true',
    'https://zoxannedev.wpengine.com/category/raw-investigates/?app_template=true',
    'https://zoxannedev.wpengine.com/category/all-video/?app_template=true',
    'https://zoxannedev.wpengine.com/app-content/?app_template=true'
  ];

  Future<bool> onBackButtonPressed() async {
    if (await c.data.canGoBack()) {
      await c.data.goBack();
      return false;
    } else {
      await Future.delayed(Duration(microseconds: 1));
      exit(0);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<WebViewController>(
        future: controller.future,
        builder: (context, snap) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              resizeToAvoidBottomPadding: true,
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
                  onPressed: () async {
                    await snap.data.goBack();
                  },
                )
                    : SizedBox(),
                title: Align(
                  alignment: AlignmentDirectional(-0.3,0.0),
                  child: Image.asset(
                    'assets/Images/raw-story-logo.jpg',
                    height: 90,
                    width: 190,
                  ),
                ),
              ),
              body: SafeArea(
                child: WillPopScope(
                  onWillPop: onBackButtonPressed,
                  child: Stack(
                    children: <Widget>[
                      WebView(
                        onPageStarted: (__) async {
                          c = snap;
                          currentUrl = await snap.data.currentUrl();
                          index = url.indexOf(currentUrl);
                          setState(() {
                            if (index != -1) currentIndex = index;
                          });
                          if (snap.hasError) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Error Occured',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: url[currentIndex],
                        onWebViewCreated: (webViewController) {
                          controller.complete(webViewController);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  selectedIconTheme: IconThemeData(size: 17),
                  unselectedIconTheme: IconThemeData(size: 26),
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.white,
                  selectedFontSize: 15,
                  selectedLabelStyle: TextStyle(color: Colors.red),
                  unselectedLabelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  onTap: (tappedIndex) async {
                    setState(() {
                      currentIndex = tappedIndex;
                    });
                    if (snap.hasData) snap.data.loadUrl(url[currentIndex]);
                  },
                  currentIndex: currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.whatshot,
                      ),
                      title: Text('Latest'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.trending_up),
                      title: Text(
                        'Trending',
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt),
                      title: Text(
                        'Exclusives',
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_library),
                      title: Text(
                        'Videos',
                      ),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.view_headline),
                      title: Text(
                        'Content',
                      ),
                    ),
                  ]));
        },
      ),
    );
  }
}
