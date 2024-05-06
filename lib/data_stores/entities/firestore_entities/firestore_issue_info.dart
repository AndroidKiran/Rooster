import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/document_converter.dart';
import 'package:rooster/data_stores/entities/firestore_entity.dart';
import 'package:rooster/data_stores/entities/issue_info.dart';

part 'firestore_issue_info.g.dart';

@JsonSerializable()
class FirestoreIssueInfo extends FireStoreEntity<IssueInfo>
    implements DocumentConverter<FirestoreIssueInfo, IssueInfo> {
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
