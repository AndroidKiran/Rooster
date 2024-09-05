import 'dart:io';

/// A utility class for retrieving platform-specific information.
class RoosterPlatform {
  /// Returns a string representing the operating system of the device.
  ///
  /// Returns "android" for Android devices, "ios" for iOS devices,
  /// and "un_known" for other platforms.
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
