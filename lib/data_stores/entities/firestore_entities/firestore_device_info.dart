import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rooster/data_stores/entities/converters/document_converter.dart';
import 'package:rooster/data_stores/entities/device_info.dart';
import 'package:rooster/data_stores/entities/firestore_entities/firestore_entity.dart';

part 'firestore_device_info.g.dart';

/// Represents device information stored in Firestore, providing methods
/// for converting between Firestore documents and [DeviceInfo] objects.
///
///This class handles JSON serialization, document conversion, and
/// value comparison, making it easier to manage device data in your
/// application.

@JsonSerializable()
class FirestoreDeviceInfo extends FireStoreEntity<DeviceInfo>
    implements DocumentConverter<FirestoreDeviceInfo, DeviceInfo> {
  @override
  final String id;
  final DeviceInfo deviceInfo;

  const FirestoreDeviceInfo({required this.id, required this.deviceInfo})
      : super(id: id, entity: deviceInfo);

  factory FirestoreDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$FirestoreDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreDeviceInfoToJson(this);

  @override
  Map<String, dynamic> toDocument(DeviceInfo model) => model.toJson();

  factory FirestoreDeviceInfo.fromDocument(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      FirestoreDeviceInfo(
          id: snapshot.id, deviceInfo: DeviceInfo.fromJson(snapshot.data()!));

  static const emptyInstance =
      FirestoreDeviceInfo(id: '', deviceInfo: DeviceInfo.emptyInstance);

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  @override
  List<Object?> get props => [id, deviceInfo];
}
