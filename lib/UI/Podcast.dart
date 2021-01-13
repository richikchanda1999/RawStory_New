import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Podcast extends StatefulWidget {
  @override
  _PodcastState createState() => _PodcastState();
}

class _PodcastState extends State<Podcast> {
  bool isLoading=true;

  WebViewController podcastController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Podcasts"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              ScreenBLoC().toScreen(Screens.HOME);
            }),
      ),
      body: Stack(
        children: [
          isLoading? Center(child: CircularProgressIndicator(),):SizedBox(),
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "https://therawstorypodcast.libsyn.com/website",
            onWebViewCreated: (controller) {
              podcastController = controller;
            },
            onPageFinished: (_){
              setState(() {
                 isLoading=false;
              });
             
            },
          ),
        ],
      ),
    );
  }
}
