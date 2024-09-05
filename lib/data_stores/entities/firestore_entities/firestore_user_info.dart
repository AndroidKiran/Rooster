import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/document_converter.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_entity.dart';
import 'package:rooster/data_stores/entities/user_info.dart';

part 'firestore_user_info.g.dart';

/// Represents user information stored in Firestore, providing methods
/// for converting between Firestore documents and [UserInfo] objects.
///
/// This class handles JSON serialization, document conversion, and
/// value comparison, making it easier to manage user data in your
/// application.

@JsonSerializable()
class FirestoreUserInfo extends FireStoreEntity<UserInfo>
    implements DocumentConverter<FirestoreUserInfo, UserInfo> {
  @override
  final String id;
  final UserInfo userEntity;

  const FirestoreUserInfo({required this.id, required this.userEntity})
      : super(id: id, entity: userEntity);

  factory FirestoreUserInfo.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreUserInfoToJson(this);

  @override
  Map<String, dynamic> toDocument(UserInfo userInfo) => userInfo.toJson();

  factory FirestoreUserInfo.fromDocument(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      FirestoreUserInfo(
          id: snapshot.id, userEntity: UserInfo.fromJson(snapshot.data()!));

  static FirestoreUserInfo fromPreferenceJson(Map<String, dynamic> doc) {
    if (doc.isEmpty) return emptyInstance;
    return FirestoreUserInfo(
        id: doc['id'],
        userEntity: UserInfo.fromPreferenceJson(doc['userEntity']));
  }

  Map<String, dynamic> toPreferenceJson() => {
        'id': id,
        'userEntity': userEntity.toPreferenceJson(),
      };

  static const emptyInstance =
      FirestoreUserInfo(id: '', userEntity: UserInfo.emptyInstance);

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  FirestoreUserInfo copyWith({String? id, UserInfo? userEntity}) {
    return FirestoreUserInfo(
        id: id ?? this.id, userEntity: userEntity ?? this.userEntity);
  }

  @override
  List<Object?> get props => [id, userEntity];
}
