import 'dart:io';

class RoosterPlatform {
  static String getDeviceOs() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else {
      return "un_known";
    }
  }
}
