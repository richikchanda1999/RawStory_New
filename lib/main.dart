import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/UI/Post.dart';
import 'UI/Home.dart';

void main() {
  bool isDebug = true;

  SectionsBLoC().init();
  SectionsBLoC().fetchSections();
  runApp(MyApp(isDebug));
}

class MyApp extends StatelessWidget {
  final bool isDebug;

  MyApp(this.isDebug);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isDebug ? Scaffold() : MyNavigator(),
    );
  }
}

class MyNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 768, height: 1024, allowFontScaling: true);
    return Builder(
      builder: (BuildContext context) {
        return StreamBuilder<Screens>(
            stream: ScreenBLoC().getScreen,
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                child: getScreen(snapshot.data ?? Screens.HOME),
                duration: Duration(milliseconds: 1500),
              );
            });
      },
    );
  }

  Widget getScreen(Screens screen) {
    switch (screen) {
      case Screens.HOME:
        return Home();
      case Screens.POST:
        return PostPage();
      default:
        return Scaffold();
    }
  }
}
