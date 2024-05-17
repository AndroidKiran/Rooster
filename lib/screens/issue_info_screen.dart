import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/blocs/issue_info_bloc/issue_bloc.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_entity.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_user_info.dart';
import 'package:rooster/widgets/rooster_tag_widget.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class IssueInfoScreen extends StatefulWidget {
  final String issueId;

  const IssueInfoScreen({super.key, required this.issueId});

  @override
  State<IssueInfoScreen> createState() => _IssueInfoScreenState();
}

class _IssueInfoScreenState extends State<IssueInfoScreen> {
  @override
  void initState() {
    super.initState();
    _triggerFetchIssueInfoEvent(widget.issueId);
  }

  @override
  void dispose() {
    // Unregister your State class as a binding observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<IssueBloc, IssueState>(
          builder: (context, issueState) {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: RoosterTextWidget(
                    text: issueState.firestoreIssueInfo.issueInfo
                        .getScreenTitle(),
                    textSize: 32,
                    textColor: Colors.grey[800],
                    maxLines: 3,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                body: _screenContent(issueState, homeState));
          },
        );
      },
    );
  }

  Widget _screenContent(IssueState state, HomeState homeState) => Container(
        alignment: Alignment.center,
        child: _content(state, homeState),
      );

  Widget _content(IssueState state, HomeState homeState) {
    switch (state.status) {
      case Status.success:
        _updateUserVisit(state.firestoreIssueInfo, homeState.firestoreUserInfo);
        return Column(
          children: [
            _headerView(state.firestoreIssueInfo),
            _issueDetails(state.firestoreIssueInfo)
          ],
        );

      case Status.failure:
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
                onPressed: () => _triggerFetchIssueInfoEvent(widget.issueId),
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

      case Status.loading:
        return const CircularProgressIndicator(
          color: Colors.deepPurpleAccent,
        );

      default:
        return const Placeholder();
    }
  }

  Widget _headerView(FirestoreIssueInfo firestoreIssueInfo) {
    return Container(
      color: Colors.red[50],
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
      child: Column(
        children: [
          Icon(
            size: 48.0,
            CupertinoIcons.timer,
            color: Colors.red[300],
          ),
          RoosterTagWidget(
              text: firestoreIssueInfo.issueInfo.appId,
              borderRadius: 16.0,
              shape: BoxShape.rectangle,
              backgroundColor: Colors.amberAccent,
              textColor: Colors.black87),
          const SizedBox(
            height: 18.0,
          ),
          Text(
            firestoreIssueInfo.issueInfo.getIssueMsg(),
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 18.0,
          ),
          ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // <-- Radius
              ),
            ),
            child: const Text(
              'Investigate issue',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _issueDetails(FirestoreIssueInfo firestoreIssueInfo) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  size: 24.0,
                  CupertinoIcons.bolt_circle_fill,
                  color: Colors.deepPurpleAccent,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  firestoreIssueInfo.issueInfo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                const Icon(
                  size: 24.0,
                  CupertinoIcons.info_circle_fill,
                  color: Colors.deepPurpleAccent,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  firestoreIssueInfo.issueInfo.subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Divider(
              thickness: 2.0,
              color: Colors.black26,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              firestoreIssueInfo.issueInfo.getFirstSeenMsg(),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );

  void _triggerFetchIssueInfoEvent(String issueId) {
    if (!context.mounted) return;
    context.read<IssueBloc>().add(FetchIssueInfoEvent(issueId: issueId));
  }

  void _updateUserVisit(FirestoreIssueInfo firestoreIssueInfo,
      FirestoreUserInfo firestoreUserInfo) {
    try {
      if (!context.mounted ||
          firestoreIssueInfo.entity.visitedUserId.isNotEmpty ||
          !firestoreUserInfo.entity.isOnCall) return;
      context.read<IssueBloc>().add(UpdateIssueInfoEvent(
          firestoreIssueInfo: firestoreIssueInfo,
          firestoreUserInfo: firestoreUserInfo));
    } catch (e) {
      log(e.toString());
    }
  }
}
