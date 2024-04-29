import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';

@immutable
class HomeItem extends Equatable {
  final IconData iconData;
  final String itemName;
  final String nextActionScreen;

  const HomeItem(
      {required this.iconData,
      required this.itemName,
      required this.nextActionScreen});

  @override
  List<Object?> get props => [iconData, itemName, nextActionScreen];

  static List<HomeItem> getHomeItems() {
    return [
      HomeItem(
          iconData: CupertinoIcons.group_solid,
          itemName: "Users",
          nextActionScreen: RoosterScreenPath.allUsersScreen.name),
      HomeItem(
          iconData: CupertinoIcons.bandage_fill,
          itemName: "VelocityCrashes",
          nextActionScreen: RoosterScreenPath.velocityCrashesScreen.name)
    ];
  }
}
