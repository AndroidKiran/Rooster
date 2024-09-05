import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';

/// Represents an item to be displayed on the home screen of the application.
///
/// Each [HomeItem] contains an icon, a name, and the route name of the
/// screen to navigate to when tapped.
///
/// This class is immutable and extends [Equatable] for easy comparison.

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
          iconData: CupertinoIcons.bell_circle_fill,
          itemName: "Crashes",
          nextActionScreen: RoosterScreenPath.allIssuesScreen.name)
    ];
  }
}
