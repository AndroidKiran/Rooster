import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:rooster/services/call_kit_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _currentUuid = '';
  final callKitService = CallKitService();

  @override
  void initState() {
    super.initState();
    _initApp();
    callKitService.listenerEvent(context, _onEvent);
  }

  @override
  void dispose() {
    callKitService.endAllCalls();
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

  Future<void> _initApp() async {
    await callKitService.requestNotificationPermission();
    final activeCall = await callKitService.initCurrentCall();
    if (activeCall != null) {
      _currentUuid = activeCall['id'];
      if (_currentUuid.isNotEmpty) {
        await callKitService.endCurrentCall(_currentUuid);
      }
    }
    if (_currentUuid.isNotEmpty) {
      await callKitService.hideCallNotification(_currentUuid);
    }
  }
}
