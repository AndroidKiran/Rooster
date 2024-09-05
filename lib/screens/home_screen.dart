import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/helpers/call_kit_manager.dart';
import 'package:rooster/screens/models/home_item.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

/// The main landing page for the application.
///
/// This screen displays the user's on-call status, provides access to/// various application features through a grid of home items, and manages
/// call-related functionality using [CallKitManager].
///
/// It uses [BlocBuilder] to access the state of [HomeBloc] and update the UI
/// accordingly.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _currentUuid = '';
  final _callKitManager = CallKitManager();
  final List<HomeItem> _homeItems = HomeItem.getHomeItems();

  @override
  void initState() {
    super.initState();
    _initApp();
    _callKitManager.listenerEvent(context, _onEvent);
    _updateTokenEvent();
  }

  @override
  void dispose() {
    _callKitManager.endAllCalls();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
          text: 'Home',
          textSize: 32,
          textColor: Colors.grey[800],
          maxLines: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              _onCallCard(),
              const SizedBox(
                height: 20,
              ),
              _homeGrid(_homeItems),
            ],
          )),
    );
  }

  void _onEvent(CallEvent event) {
    if (!mounted) return;
  }

  Future<void> _initApp() async {
    await _callKitManager.requestNotificationPermission();
    final activeCall = await _callKitManager.initCurrentCall();
    if (activeCall != null) {
      _currentUuid = activeCall['id'];
      if (_currentUuid.isNotEmpty) {
        await _callKitManager.endCurrentCall(_currentUuid);
      }
    }
    if (_currentUuid.isNotEmpty) {
      await _callKitManager.hideCallNotification(_currentUuid);
    }
  }

  Future<void> _updateTokenEvent() async {
    if (context.mounted) {
      context.read<HomeBloc>().add(UpdateTokenEvent());
    }
  }

  Widget _onCallCard() => BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          FirestoreUserInfo firestoreUserInfo = state.firestoreUserInfo;
          final UserInfo userInfo = firestoreUserInfo.userEntity;
          bool areYouOnCall = userInfo.isOnCall;
          Color cardColor = Colors.deepPurpleAccent;
          if (areYouOnCall) {
            cardColor = Colors.green;
          }

          String message = 'Relax you are off duty';
          if (areYouOnCall) {
            message = 'You are on onCall duty, Be alert';
          }

          IconData iconData = CupertinoIcons.eye_slash_fill;
          if (areYouOnCall) {
            iconData = CupertinoIcons.eye_solid;
          }

          return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              hoverColor: Colors.red[200],
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  context.pushNamed(RoosterScreenPath.onCallPolicyScreen.name),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      size: 40,
                      iconData,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    RoosterTextWidget(
                      text: message,
                      textSize: 16,
                      textColor: Theme.of(context).colorScheme.onInverseSurface,
                      maxLines: 1,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Icon(
                      size: 20,
                      CupertinoIcons.chevron_right_circle_fill,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );

  Widget _homeGrid(List<HomeItem> homeItems) =>
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return GridView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: homeItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return _homeItem(homeItems[index], state.firestoreUserInfo);
              });
        },
      );

  Widget _homeItem(HomeItem homeItem, FirestoreUserInfo firestoreUserInfo) =>
      Card(
        color: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          hoverColor: Colors.red[200],
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => context.pushNamed(homeItem.nextActionScreen),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 90,
                  homeItem.iconData,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoosterTextWidget(
                    text: homeItem.itemName,
                    textSize: 24.0,
                    textColor: Colors.grey[800],
                    maxLines: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
