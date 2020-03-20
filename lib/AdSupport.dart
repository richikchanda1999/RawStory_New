import 'dart:io';

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