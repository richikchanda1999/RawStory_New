import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raw_story_new/BLoC/Home.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/SplashScreen.dart';
import 'package:raw_story_new/UI/BookmarkedStories.dart';
import 'package:raw_story_new/UI/ContriPage.dart';
import 'package:raw_story_new/UI/Login.dart';
import 'package:raw_story_new/UI/Post.dart';
import 'package:raw_story_new/UI/Settings.dart';
import 'package:raw_story_new/UI/Subscription.dart';
import 'UI/About.dart';
import 'UI/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDebug = false;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await SystemChrome.setEnabledSystemUIOverlays([]);

  SectionsBLoC().init();
  PostsBLoC().init();
  PostsBLoC().fetchPosts(20, 0, SectionsBLoC.sectionURLS[0]);
  HomeBLoC().init();
  runApp(MyApp(isDebug));
}

class MyApp extends StatelessWidget {
  final bool isDebug;

  MyApp(this.isDebug);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: isDebug,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Nirmait'
      ),
      home: SplashLogo(isDebug ? Scaffold() : MyNavigator()),
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
                child: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: getScreen(snapshot.data ?? Screens.SUBSCRIPTIONS)),
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
      case Screens.SUBSCRIPTIONS:
        return SubsPage();
      case Screens.ABOUT:
        return About();
      case Screens.SETTINGS:
        return Settings();
      case Screens.BOOKMARKED_STORIES:
        return BookmarkedStories();
      case Screens.LOGIN:
        return LoginPage();
      case Screens.CONTRI:
        return ContributionPage();
    }
  }
}
