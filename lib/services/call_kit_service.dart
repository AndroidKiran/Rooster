import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';

class CallKitService {
  static Future<void> showCallkitIncoming(String uuid) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: 'Rooster',
      appName: 'Rooster',
      avatar: 'assets/icons/icon_rooster.png',
      handle: '9009900990',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Rooster Missed Call',
        callbackText: 'View Velocity Crash',
      ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#FFFF9800',
        backgroundUrl: 'assets/test.png',
        actionColor: '#FFFFD740',
        textColor: '#ffffff',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }

  static Future<void> listenerEvent(
      BuildContext context, void Function(CallEvent) callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        log('CallKitService: $event');
        switch (event!.event) {
          case Event.actionCallAccept:
            context.goNamed(RoosterScreenPath.velocityCrashInfoScreen.name);
            break;
          case Event.actionCallDecline:
            context.goNamed(RoosterScreenPath.velocityCrashInfoScreen.name);
            break;
          default:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      print(e);
    }
  }
}
