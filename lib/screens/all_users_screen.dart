import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:rooster/widgets/rooster_tag_widget.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
            text: 'All Users',
            textSize: 32,
            textColor: Colors.grey[800],
            maxLines: 3),
      ),
      body: _userListView(),
    );
  }

  Widget _userListView() => FirestoreListView<FirestoreUserInfo>(
        shrinkWrap: true,
        query: FirebaseManager().userDb,
        pageSize: 20,
        emptyBuilder: (context) => RoosterTextWidget(
            text: 'No data available',
            textSize: 16,
            textColor: Colors.grey[800],
            maxLines: 1),
        errorBuilder: (context, error, stackTrace) => RoosterTextWidget(
            text: 'Some thing went wrong',
            textSize: 16,
            textColor: Colors.grey[800],
            maxLines: 1),
        loadingBuilder: (context) => const CircularProgressIndicator(),
        itemBuilder: (context, doc) {
          return _userTile(doc.data());
        },
      );

  Widget _userTile(FirestoreUserInfo firestoreUserInfo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => context.pushNamed(""),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge(
                alignment: AlignmentDirectional.topStart,
                backgroundColor: Colors.amberAccent,
                isLabelVisible: firestoreUserInfo.userEntity.isOnCall,
                label: const RoosterTextWidget(
                    text: 'OnCall', textSize: 6.0, textColor: Colors.black87),
                child: Icon(
                  size: 48,
                  CupertinoIcons.person_alt_circle_fill,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8.0),
              _userInfo(firestoreUserInfo),
              const SizedBox(width: 8.0),
              Icon(
                size: 20,
                CupertinoIcons.chevron_right_circle_fill,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo(FirestoreUserInfo firestoreUserInfo) {
    final UserInfo userInfo = firestoreUserInfo.userEntity;
    Color tagBgColor = Colors.green;
    if (userInfo.deviceInfoRef.isEmpty) {
      tagBgColor = Colors.redAccent;
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoosterTextWidget(
              text: userInfo.getUserName(),
              textSize: 18,
              textColor: Colors.grey[800],
              maxLines: 1,
              fontWeight: FontWeight.w800),
          RoosterTagWidget(
              text: userInfo.getAccountTag(),
              borderRadius: 12.0,
              shape: BoxShape.rectangle,
              backgroundColor: tagBgColor,
              textColor: Colors.white)
        ],
      ),
    );
  }
}
