import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdSupport{
  String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1244825334086971~6599780093';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1244825334086971~6599780093';
    }
    return null;
  }
  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-1244825334086971/8719225713";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-1244825334086971/8719225713";
    }
    return null;
  }

}


MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['news'],
  contentUrl: 'https://flutter.io',
  // ignore: deprecated_member_use
  birthday: DateTime.now(),
  childDirected: false,
  // ignore: deprecated_member_use
  designedForFamilies: false,
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.banner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);