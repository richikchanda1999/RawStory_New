import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raw_story_new/AdSupport.dart';
import 'package:raw_story_new/BLoC/Home.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Notifications/Notifications.dart';
import 'package:raw_story_new/Settings/Themes.dart';
import 'package:raw_story_new/SplashScreen.dart';
import 'package:raw_story_new/Settings/ThemesProvider.dart';
import 'package:raw_story_new/UI/BookmarkedStories.dart';
import 'package:raw_story_new/UI/ContriPage.dart';
import 'package:raw_story_new/UI/Login.dart';
import 'package:raw_story_new/UI/Newsletter.dart';
import 'package:raw_story_new/UI/Podcast.dart';
import 'package:raw_story_new/UI/Post.dart';
import 'package:raw_story_new/UI/Settings.dart';
import 'package:raw_story_new/UI/Subscription.dart';
import 'package:workmanager/workmanager.dart';
import 'UI/About.dart';
import 'UI/Home.dart';

final FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask("2", "RawStoryBackgroundTask",
      frequency: Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected));

  bool isDebug = false;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await SystemChrome.setEnabledSystemUIOverlays([]);

  SectionsBLoC().init();
  PostsBLoC().init();
  PostsBLoC().fetchPosts(20, 0, SectionsBLoC.sectionURLS[0]);
  HomeBLoC().init();

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flip.getNotificationAppLaunchDetails();

  bool didNotificationLauncApp =
      notificationAppLaunchDetails.didNotificationLaunchApp;
  String payload;
  if (didNotificationLauncApp) payload = notificationAppLaunchDetails.payload;

  runApp(MyApp(
    isDebug,
    didNotificationLauncApp,
    payload: payload,
  ));
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    var android = AndroidInitializationSettings('launcher_icon');
    var iOS = IOSInitializationSettings();

    var settings = InitializationSettings(android: android, iOS: iOS);

    flip.initialize(
      settings,
    );

    var nm = await NotificationWorks().getNotifications();

    await _showNotificationWithDefaultSound(flip, nm);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(
    FlutterLocalNotificationsPlugin flip, List<NotificationModel> nm) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'News Feeds Channel',
    'Notification channel for daily doses of hot topics',
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  String payload = nm[0].title +
      " ----:: desc ::---- " +
      nm[0].desc +
      " ----:: shareUrl ::---- " +
      nm[0].shareUrl +
      " ----:: date ::---- " +
      nm[0].dateTime +
      " ----:: creator ::---- " +
      nm[0].creator;
  await flip.show(
    0,
    'RawStory',
    nm[0].title,
    platformChannelSpecifics,
    payload: payload,
  );
}

class MyApp extends StatefulWidget {
  final bool isDebug, didNotificationLaunchApp;
  String payload;
  MyApp(this.isDebug, this.didNotificationLaunchApp, {this.payload});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    initializeForegroundNotifications();
  }



  void initializeForegroundNotifications() {
    var android = AndroidInitializationSettings('launcher_icon');
    var iOS = IOSInitializationSettings();

    var settings = InitializationSettings(android: android, iOS: iOS);

    flip.initialize(settings, onSelectNotification: (String payload) async {
      List<String> patterns = [
        " ----:: desc ::---- ",
        " ----:: shareUrl ::---- ",
        " ----:: date ::---- ",
        " ----:: creator ::---- "
      ];

      List<String> data = payload.split(patterns[0]);
      String title = data.elementAt(0);
      List<String> descUrlDateCreator = data.elementAt(1).split(patterns[1]);
      String desc = descUrlDateCreator.elementAt(0);
      List<String> urlDateCreator =
          descUrlDateCreator.elementAt(1).split(patterns[2]);
      String shareUrl = urlDateCreator.elementAt(0);
      List<String> dateCreator = urlDateCreator.elementAt(1).split(patterns[3]);
      String dateTime = dateCreator.elementAt(0);
      String creator = dateCreator.elementAt(1);

      NotificationProvider().nm =
          NotificationModel(title, desc, shareUrl, dateTime, creator: creator);
      await ScreenBLoC().toScreen(Screens.POSTFROMNOTIFICATION);
      debugPrint("Ho gaya foreground notification");
      return Future.value(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: AdSupport().getAppId());
    return ChangeNotifierProvider(
      create: (_) {
        return ThemeProvider();
      },
      child: Consumer<ThemeProvider>(
   
        builder: (context,value, child) {
          
        return FutureBuilder<bool>(
          future: value.getCurrentTheme,
          builder: (context, snapshot) {
            print(snapshot.data);
            return snapshot.hasData? MaterialApp(
              debugShowCheckedModeBanner: widget.isDebug,
              theme: Themes.themeData(false, context),
              darkTheme: Themes.themeData(true, context),
              themeMode: (snapshot.data? ThemeMode.dark:ThemeMode.light),
              home: SplashLogo(widget.isDebug
                  ? Scaffold()
                  : MyNavigator(
                      widget.didNotificationLaunchApp,
                      payload: widget.payload,
                    )),
            ):SizedBox();
          }
        );
      }),
    );
  }
}

class MyNavigator extends StatelessWidget {
  final bool didNotificationLaunchApp;
  final String payload;


  MyNavigator(this.didNotificationLaunchApp, {this.payload});

  NotificationModel getNotificationModelFromPayload(String payload) {
    List<String> patterns = [
      " ----:: desc ::---- ",
      " ----:: shareUrl ::---- ",
      " ----:: date ::---- ",
      " ----:: creator ::---- "
    ];

    List<String> data = payload.split(patterns[0]);
    String title = data.elementAt(0);
    List<String> descUrlDateCreator = data.elementAt(1).split(patterns[1]);
    String desc = descUrlDateCreator.elementAt(0);
    List<String> urlDateCreator =
        descUrlDateCreator.elementAt(1).split(patterns[2]);
    String shareUrl = urlDateCreator.elementAt(0);
    List<String> dateCreator = urlDateCreator.elementAt(1).split(patterns[3]);
    String dateTime = dateCreator.elementAt(0);
    String creator = dateCreator.elementAt(1);

    return NotificationModel(title, desc, shareUrl, dateTime, creator: creator);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 768, height: 1024, allowFontScaling: true);
    return Builder(
      builder: (BuildContext context) {
        
        return StreamBuilder<Screens>(
            stream: ScreenBLoC().getScreen,
            builder: (context, snapshot) {
            
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 600),
                  child: getScreen(
                      snapshot.hasData
                          ? snapshot.data
                          : (didNotificationLaunchApp
                              ? Screens.POSTFROMNOTIFICATION
                              : Screens.SUBSCRIPTIONS),
                      notificationModel: didNotificationLaunchApp
                          ? getNotificationModelFromPayload(this.payload)
                          : NotificationProvider().nm,
                         
                          ),
                      
                ),
              );
            });
      },
    );
  }

  Widget getScreen(Screens screen, {NotificationModel notificationModel}) {
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
      case Screens.PODCASTS:
        return Podcast();
      case Screens.BOOKMARKED_STORIES:
        return BookmarkedStories();
      case Screens.LOGIN:
        return LoginPage();
      case Screens.CONTRI:
        return ContributionPage();
      case Screens.POSTFROMNOTIFICATION:
        return PostFromNotification(
          notificationModel: notificationModel,
        );
      case Screens.NEWSLETTER:
        return NewsLetter();
    }
  }
}

class NotificationProvider {
  static final NotificationProvider nf = NotificationProvider._internal();

  factory NotificationProvider() {
    return nf;
  }
  NotificationProvider._internal();

  NotificationModel nm = NotificationModel('', '', '', '');
}
