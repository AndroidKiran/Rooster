import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/blocs/user_info_block/user_info_bloc.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/data_stores/entities/user_info.dart';
import 'package:rooster/widgets/rooster_tag_widget.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;

  const UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  void initState() {
    super.initState();
    _triggerFetchUserInfoEvent(widget.userId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        if (mounted &&
            state.status == Status.deleteSuccess &&
            context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: RoosterTextWidget(
              text: "User Info",
              textSize: 32,
              textColor: Colors.grey[800],
              maxLines: 3),
        ),
        body: _screenContent(),
        floatingActionButton: _onCallStatusUpdate(),
      ),
    );
  }

  Widget _screenContent() => BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            child: _content(state),
          );
        },
      );

  Widget _content(UserInfoState state) {
    switch (state.status) {
      case Status.fetchSuccess:
        return Column(
          children: [
            _headerView(state.firestoreUserInfo),
            _userDetails(state.firestoreUserInfo)
          ],
        );

      case Status.fetchFailure:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoosterTextWidget(
                  text: 'Some thing went wrong',
                  textSize: 16,
                  textColor: Colors.grey[800],
                  maxLines: 1),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () => _triggerFetchUserInfoEvent(widget.userId),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fixedSize: const Size(220.0, 48.0),
                  side: const BorderSide(
                      color: Colors.deepPurpleAccent, width: 2.0),
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
            ],
          ),
        );

      case Status.init:
      case Status.loading:
        return const CircularProgressIndicator(
          color: Colors.deepPurpleAccent,
        );

      default:
        return const Placeholder();
    }
  }

  Widget _headerView(FirestoreUserInfo firestoreUserInfo) {
    Color tagBgColor = Colors.green;
    if (firestoreUserInfo.userEntity.deviceInfoRef.isEmpty) {
      tagBgColor = Colors.redAccent;
    }
    return Container(
      width: double.infinity,
      color: Colors.deepPurpleAccent[100],
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
      child: Column(
        children: [
          Icon(
            size: 200.0,
            CupertinoIcons.person_alt_circle_fill,
            color: Colors.deepPurpleAccent[700],
          ),
          Visibility(
            visible: firestoreUserInfo.userEntity.isOnCall,
            child: const RoosterTagWidget(
                text: "OnCall",
                borderRadius: 16.0,
                shape: BoxShape.rectangle,
                backgroundColor: Colors.amberAccent,
                textColor: Colors.black87),
          ),
          const SizedBox(
            height: 8.0,
          ),
          RoosterTagWidget(
              text: firestoreUserInfo.userEntity.getAccountTag(),
              borderRadius: 12.0,
              shape: BoxShape.rectangle,
              backgroundColor: tagBgColor,
              textColor: Colors.white),
          const SizedBox(
            height: 18.0,
          ),
          _deleteUser(firestoreUserInfo)
        ],
      ),
    );
  }

  Widget _deleteUser(FirestoreUserInfo firestoreUserInfo) =>
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Visibility(
            visible: state.firestoreUserInfo.userEntity.isAdmin &&
                !firestoreUserInfo.userEntity.isAdmin,
            child: ElevatedButton(
              onPressed: () {
                if (firestoreUserInfo.userEntity.isAdmin) return;
                context.read<UserInfoBloc>().add(
                    UserInfoDeleteEvent(firestoreUserInfo: firestoreUserInfo));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // <-- Radius
                ),
              ),
              child: const Visibility(
                visible: true,
                child: Text(
                  'Delete user',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ),
          );
        },
      );

  Widget _userDetails(FirestoreUserInfo firestoreUserInfo) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              firestoreUserInfo.userEntity.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36.0,
                color: Colors.black87,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 12.0,
            ),
            Text(
              firestoreUserInfo.userEntity.email,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                color: Colors.black45,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

  Widget _onCallStatusUpdate() => BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          return BlocBuilder<UserInfoBloc, UserInfoState>(
            builder: (context, userInfoState) {
              return Visibility(
                  visible: homeState.firestoreUserInfo.userEntity.isAdmin,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      final UserInfo userInfo =
                          userInfoState.firestoreUserInfo.userEntity;
                      final updateUserInfo = userInfo.copyWith(
                          isOnCall: !userInfo.isOnCall,
                          modifiedAt: Timestamp.now().millisecondsSinceEpoch);
                      final firestoreUserInfo = userInfoState.firestoreUserInfo
                          .copyWith(userEntity: updateUserInfo);
                      context.read<UserInfoBloc>().add(UserInfoUpdatedEvent(
                          firestoreUserInfo: firestoreUserInfo));
                    },
                    backgroundColor: Colors.deepPurpleAccent,
                    icon: const Icon(
                      Icons.perm_contact_cal,
                      color: Colors.white,
                    ),
                    label: Text(
                      userInfoState.firestoreUserInfo.userEntity
                          .getOnCallText(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ));
            },
          );
        },
      );

  void _triggerFetchUserInfoEvent(String userId) {
    if (context.mounted) {
      context.read<UserInfoBloc>().add(UserInfoStreamEvent(userId: userId));
    }
  }
}
