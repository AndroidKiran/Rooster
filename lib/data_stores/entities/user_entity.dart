import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String userId;

  final String email;
  bool get isValidEmail => email.length > 3;

  final String name;

  final bool isOnCall;

  const UserEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.isOnCall
  });

  Map<String, Object?> toJson() {
    return {
      'userId' : userId,
      'email' : email,
      'name' : name,
      'isOnCall' : isOnCall
    };
  }

  bool isEmptyInstance() {
    return this == emptyInstance;
  }

  UserEntity copyWith({
    String? userId,
    String? email,
    String? name,
    bool? isOnCall
  }) {
    return UserEntity(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        isOnCall: isOnCall ?? this.isOnCall
    );
  }

  static UserEntity fromJson(Map<String, dynamic> doc) {
    if(doc.isEmpty) return emptyInstance;
    return UserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        isOnCall: doc['isOnCall']
    );
  }

  static const emptyInstance = UserEntity(
      userId: '',
      email: '',
      name: '',
      isOnCall: false
  );

  @override
  List<Object?> get props => [userId, email, name, isOnCall];

}