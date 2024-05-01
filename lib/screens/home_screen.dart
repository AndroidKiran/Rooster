import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/data_stores/entities/user_entity.dart';
import 'package:rooster/screens/models/home_item.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/services/call_kit_service.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _currentUuid = '';
  final _callKitService = CallKitService();
  final List<HomeItem> _homeItems = HomeItem.getHomeItems();

  @override
  void initState() {
    super.initState();
    _initApp();
    _callKitService.listenerEvent(context, _onEvent);
  }

  @override
  void dispose() {
    _callKitService.endAllCalls();
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
            maxLines: 1),
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
    await _callKitService.requestNotificationPermission();
    final activeCall = await _callKitService.initCurrentCall();
    if (activeCall != null) {
      _currentUuid = activeCall['id'];
      if (_currentUuid.isNotEmpty) {
        await _callKitService.endCurrentCall(_currentUuid);
      }
    }
    if (_currentUuid.isNotEmpty) {
      await _callKitService.hideCallNotification(_currentUuid);
    }
  }

  Widget _onCallCard() => BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          UserEntity user = UserEntity.emptyInstance;
          if (state is OnCallState) {
            user = state.onCallUser;
          }
          bool areYouOnCall = user.isOnCall;
          Color cardColor = Colors.white70;
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

  Widget _homeGrid(List<HomeItem> homeItems) => GridView.builder(
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
        return _homeItem(homeItems[index]);
      });

  Widget _homeItem(HomeItem homeItem) => Card(
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
