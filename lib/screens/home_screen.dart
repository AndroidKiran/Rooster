import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:rooster/services/call_kit_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String? _currentUuid;

  @override
  void initState() {
    super.initState();
    _currentUuid = "";
    _initCurrentCall();
    CallKitService.listenerEvent(context, _onEvent);
  }

  @override
  void dispose() {
    _endCurrentCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          FirebaseCrashlytics.instance.crash();
        },
        child: const Text("Crash me"));
  }

  void _onEvent(CallEvent event) {
    if (!mounted) return;
  }

  Future<dynamic> _initCurrentCall() async {
    await _requestNotificationPermission();
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  Future<void> _endCurrentCall() async {
    _initCurrentCall();
    await FlutterCallkitIncoming.endCall(_currentUuid!);
  }

  Future<void> _requestNotificationPermission() async {
    await FlutterCallkitIncoming.requestNotificationPermission({
      "rationaleMessagePermission":
          "Notification permission is required, to show notification.",
      "postNotificationMessageRequired":
          "Notification permission is required, Please allow notification permission from setting."
    });
  }
}
