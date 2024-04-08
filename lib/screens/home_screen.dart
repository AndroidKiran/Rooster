import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:rooster/services/call_kit_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    CallKitService.listenerEvent(context, onEvent);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void onEvent(CallEvent event) {
    if (!mounted) return;
  }
}
