import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class AdSupport {
  AdSupport._privateConstructor();
  static final AdSupport adSupportPrivate = AdSupport._privateConstructor();

  factory AdSupport() {
    return adSupportPrivate;
  }

  NativeAdmobController nativeAdController = NativeAdmobController();

  NativeAdmob nativeAd;
  // BannerAd myBanner;

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

  void dispose() async {
    // await myBanner?.dispose();
    nativeAdController.dispose();
    // myBanner = null;
    nativeAdController = null;
    nativeAd = null;
  }

  void initialize(double height) {
    // FirebaseAdMob.instance.initialize(appId: AdSupport().getAppId());

    // myBanner = BannerAd(
    //   adUnitId: BannerAd.testAdUnitId,
    //   size: AdSize.banner,
    //   targetingInfo: MobileAdTargetingInfo(
    //     keywords: <String>['news'],
    //     contentUrl: 'https://flutter.io',
    //     childDirected: false,
    //   ),
    //   listener: (MobileAdEvent event) {
    //     print("BannerAd event is $event");
    //   },
    // );

    // myBanner
    //   ..load().then((loaded) async {
    //     if (loaded) {
    //       try {
    //         myBanner..show(anchorOffset: height);
    //       } catch (error) {
    //         print(error);
    //       }
    //     }
    //   });

    nativeAdController = NativeAdmobController();
    nativeAd = NativeAdmob(
        adUnitID: NativeAd.testAdUnitId,
        loading: Center(child: CircularProgressIndicator()),
        error: Text("Failed to load the ad"),
        controller: nativeAdController,
        type: NativeAdmobType.full,
        options: NativeAdmobOptions(
          ratingColor: Colors.red,
          // Others ...
        ));
  }
}
