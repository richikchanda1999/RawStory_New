import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:raw_story_new/BLoC/Home.dart';
import 'package:raw_story_new/BLoC/Post.dart';
import 'package:raw_story_new/BLoC/Screens.dart';
import 'package:raw_story_new/BLoC/Sections.dart';
import 'package:raw_story_new/Notifications/Notifications.dart';
import 'package:raw_story_new/Settings/NotificationPreference.dart';
import 'package:raw_story_new/Settings/Themes.dart';
import 'package:raw_story_new/Settings/SizeProvider.dart';
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
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(
    callbackDispatcher,
  );
  bool isNotificationEnabled = await NotificationPreference().getPreference();

  if (isNotificationEnabled)
    Workmanager.registerPeriodicTask("RawStoryTask", "RawStoryBackgroundTask",
        frequency: Duration(hours: 2),
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
    var android = AndroidInitializationSettings('notification_icon');
    var iOS = IOSInitializationSettings();

    var settings = InitializationSettings(android: android, iOS: iOS);

    flip.initialize(
      settings,
    );

    var nm = await NotificationWorks().getNotifications();

    await _showNotificationWithDefaultSoundAndBigPicture(flip, nm);
    return Future.value(true);
  });
}

Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(url);
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future _showNotificationWithDefaultSoundAndBigPicture(
    FlutterLocalNotificationsPlugin flip, List<NotificationModel> nm) async {
  final String bigPicPath = nm[0].imgUrl != null
      ? await _downloadAndSaveFile(nm[0].imgUrl, 'bigPic')
      : '';
  var bigPictureStyleInformation = BigPictureStyleInformation(
    bigPicPath != ''
        ? FilePathAndroidBitmap(bigPicPath)
        : DrawableResourceAndroidBitmap("launcher_icon"),
    largeIcon: DrawableResourceAndroidBitmap("launcher_icon"),
    summaryText: "<p><b>${nm[0].title}</b></p>",
    htmlFormatSummaryText: true,
  );

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'News Feeds Channel',
      'Notification channel for daily doses of hot topics',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation);
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
    'Raw Story',
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
    var android = AndroidInitializationSettings('notification_icon');
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<FontSizeProvider>(
          create: (_) => FontSizeProvider(),
        )
      ],
      builder: (context, child) {
        final themeProvider = context.watch<ThemeProvider>();

        return FutureBuilder<bool>(
            future: themeProvider.getCurrentTheme,
            builder: (context, snapshot) {
              print(snapshot.data);

              return snapshot.hasData
                  ? MaterialApp(
                      debugShowCheckedModeBanner: widget.isDebug,
                      theme: Themes.themeData(false, context),
                      darkTheme: Themes.themeData(true, context),
                      themeMode:
                          (snapshot.data ? ThemeMode.dark : ThemeMode.light),
                      home: SplashLogo(widget.isDebug
                          ? Scaffold()
                          : MyNavigator(widget.didNotificationLaunchApp,
                              payload: widget.payload, isDark: snapshot.data)),
                    )
                  : SizedBox();
            });
      },
    );
  }
}

class MyNavigator extends StatelessWidget {
  final bool didNotificationLaunchApp;
  final String payload;
  final bool isDark;

  MyNavigator(this.didNotificationLaunchApp, {this.payload, this.isDark});

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
                  if (snapshot.hasData) {
                    if (snapshot.data == Screens.HOME)
                      return true;
                    else {
                      ScreenBLoC().toScreen(Screens.HOME);
                    }
                  }
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
                      isDark: isDark),
                ),
              );
            });
      },
    );
  }

  Widget getScreen(Screens screen,
      {NotificationModel notificationModel, bool isDark}) {
    switch (screen) {
      case Screens.HOME:
        return Home();
      case Screens.POST:
        return PostPage(isDark: isDark);
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
            notificationModel: notificationModel, isDark: isDark);
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

  NotificationModel nm = NotificationModel(
    '',
    '',
    '',
    '',
  );
}
