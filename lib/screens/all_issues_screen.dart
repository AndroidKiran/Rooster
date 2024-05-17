import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_issue_info.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';
import 'package:rooster/helpers/firebase_manager.dart';
import 'package:rooster/screens/routes/rooster_screen_path.dart';
import 'package:rooster/widgets/rooster_tag_widget.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class AllIssuesScreen extends StatefulWidget {
  const AllIssuesScreen({super.key});

  @override
  State<AllIssuesScreen> createState() => _AllIssuesScreenState();
}

class _AllIssuesScreenState extends State<AllIssuesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
          text: 'Velocity Crashes',
          textSize: 32.0,
          textColor: Colors.grey[800],
          maxLines: 1,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: _crashListView(),
    );
  }

  Widget _crashListView() => FirestoreListView<FirestoreIssueInfo>(
        shrinkWrap: true,
        query: FirebaseManager().issueDb,
        pageSize: 20,
        emptyBuilder: (context) => Container(
          alignment: Alignment.center,
          child: RoosterTextWidget(
              text: 'No data available',
              textSize: 16,
              textColor: Colors.grey[800],
              maxLines: 1),
        ),
        errorBuilder: (context, error, stackTrace) => Container(
          alignment: Alignment.center,
          child: RoosterTextWidget(
              text: 'Some thing went wrong',
              textSize: 16,
              textColor: Colors.grey[800],
              maxLines: 1),
        ),
        loadingBuilder: (context) => Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator()),
        itemBuilder: (context, doc) {
          return _crashInfoTile(doc.data(), context);
        },
      );

  Widget _crashInfoTile(
      FirestoreIssueInfo firestoreIssueInfo, BuildContext context) {
    Color cardColor = Colors.white70;
    if (firestoreIssueInfo.entity.visitedUserId.isEmpty) {
      cardColor = Colors.red[300] ?? Colors.white70;
    }
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => context.pushNamed(RoosterScreenPath.issueInfoScreen.name,
            pathParameters: {'issueId': firestoreIssueInfo.id}),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                size: 48.0,
                CupertinoIcons.bell_circle_fill,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8.0),
              _crashInfo(firestoreIssueInfo.issueInfo),
              const SizedBox(width: 8.0),
              const Icon(
                size: 20.0,
                CupertinoIcons.chevron_right_circle_fill,
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crashInfo(IssueInfo issueInfo) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoosterTextWidget(
              text: issueInfo.title,
              textSize: 14.0,
              textColor: Colors.black87,
              maxLines: 1,
              fontWeight: FontWeight.w800),
          const SizedBox(
            height: 2.0,
          ),
          RoosterTextWidget(
              text: issueInfo.subtitle,
              textSize: 12.0,
              textColor: Colors.black54,
              maxLines: 1,
              fontWeight: FontWeight.w600),
          const SizedBox(
            height: 8.0,
          ),
          RoosterTagWidget(
              text: issueInfo.type,
              borderRadius: 12.0,
              shape: BoxShape.rectangle,
              backgroundColor: Colors.amberAccent,
              textColor: Colors.black87)
        ],
      ),
    );
  }
}
