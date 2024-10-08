import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository_impl.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// A class that handles interactions with the [flutter_callkit_incoming]
/// plugin to display and manage incoming call-like notifications in the
/// Flutter application.
///
/// This class implements a singleton pattern to ensure that only one
/// instance of the CallKit manager is created and used throughout the
/// application.
///
/// It provides methods for displaying incoming call notifications,
/// responding to user actions (accept/decline), managing active calls,
/// and requesting necessary permissions.

class CallKitManager {
  static final CallKitManager _singleton = CallKitManager._();

  factory CallKitManager() => _singleton;

  CallKitManager._();

  Future<void> showCallkitIncoming(String uuid) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: 'Rooster Alert',
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

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  }

  Future<void> listenerEvent(
      BuildContext context, void Function(CallEvent) callback) async {
    final preferences = await StreamingSharedPreferences.instance;
    final issueRepository =
        IssueRepositoryImplementation(preferences: preferences);
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        log('CallKitService: $event');
        switch (event!.event) {
          case Event.actionCallAccept:
            final issueId = await issueRepository.getIssueId();
            if (!context.mounted) return;
            context.pushNamed(RoosterScreenPath.issueInfoScreen.name,
                pathParameters: {'issueId': issueId});
            break;
          case Event.actionCallDecline:
            break;
          default:
            break;
        }
        callback(event);
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> initCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        // _currentUuid = calls[0]['id'];
        return calls[0];
      }
    }
    return null;
  }

  Future<dynamic> endCurrentCall(String currentUuid) async {
    return await FlutterCallkitIncoming.endCall(currentUuid);
  }

  Future<dynamic> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> requestNotificationPermission() async {
    await FlutterCallkitIncoming.requestNotificationPermission({
      "rationaleMessagePermission":
          "Notification permission is required, to show notification.",
      "postNotificationMessageRequired":
          "Notification permission is required, Please allow notification permission from setting."
    });
  }

  Future<dynamic> hideCallNotification(String currentUuid) async {
    CallKitParams params = CallKitParams(id: currentUuid);
    return await FlutterCallkitIncoming.hideCallkitIncoming(params);
  }
}
