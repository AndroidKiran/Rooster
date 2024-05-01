import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rooster/data_stores/entities/crash_info.dart';
import 'package:rooster/services/firebase_service.dart';
import 'package:rooster/widgets/rooster_tag_widget.dart';
import 'package:rooster/widgets/rooster_text_widget.dart';

class CrashesScreen extends StatelessWidget {
  const CrashesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RoosterTextWidget(
            text: 'Velocity Crashes',
            textSize: 32,
            textColor: Colors.grey[800],
            maxLines: 1),
      ),
      body: _crashListView(),
    );
  }

  Widget _crashListView() => FirestoreListView<CrashInfo>(
        shrinkWrap: true,
        query: FirebaseService().crashDb,
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
          return _crashInfoTile(doc.data(), context);
        },
      );

  Widget _crashInfoTile(CrashInfo crashInfo, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
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
              Icon(
                size: 48,
                CupertinoIcons.bell_circle_fill,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8.0),
              _crashInfo(crashInfo),
              const SizedBox(width: 8.0),
              const Icon(
                size: 20,
                CupertinoIcons.chevron_right_circle_fill,
                color: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crashInfo(CrashInfo crashInfo) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoosterTextWidget(
              text: crashInfo.title,
              textSize: 14,
              textColor: Colors.black87,
              maxLines: 1,
              fontWeight: FontWeight.w800),
          const SizedBox(
            height: 2.0,
          ),
          RoosterTextWidget(
              text: crashInfo.subtitle,
              textSize: 12,
              textColor: Colors.black54,
              maxLines: 1,
              fontWeight: FontWeight.w600),
          const SizedBox(
            height: 8.0,
          ),
          RoosterTagWidget(
              text: crashInfo.type,
              borderRadius: 12.0,
              shape: BoxShape.rectangle,
              backgroundColor: Colors.amberAccent,
              textColor: Colors.black87)
        ],
      ),
    );
  }
}
