import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/document_converter.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_entity.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';

part 'firestore_issue_info.g.dart';

/// Represents issue information stored in Firestore, providing methods
/// for converting between Firestore documents and [IssueInfo] objects.
/// This class handles JSON serialization, document conversion, and
/// value comparison, making it easier to manage issue data in your
/// application.

@JsonSerializable()
class FirestoreIssueInfo extends FireStoreEntity<IssueInfo>
    implements DocumentConverter<FirestoreIssueInfo, IssueInfo> {
  @override
  final String id;
  final IssueInfo issueInfo;

  const FirestoreIssueInfo({required this.id, required this.issueInfo})
      : super(id: id, entity: issueInfo);

  factory FirestoreIssueInfo.fromJson(Map<String, dynamic> json) =>
      _$FirestoreIssueInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreIssueInfoToJson(this);

  @override
  Map<String, dynamic> toDocument(IssueInfo model) => model.toJson();

  factory FirestoreIssueInfo.fromDocument(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      FirestoreIssueInfo(
          id: snapshot.id, issueInfo: IssueInfo.fromJson(snapshot.data()!));

  static const emptyInstance =
      FirestoreIssueInfo(id: '', issueInfo: IssueInfo.emptyInstance);

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  @override
  List<Object?> get props => [id, issueInfo];
}
