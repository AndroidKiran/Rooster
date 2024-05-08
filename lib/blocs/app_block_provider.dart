import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/blocs/employee_verification_bloc/employee_verification_bloc.dart';
import 'package:rooster/blocs/firebase_messaging_bloc/firebase_messaging_bloc.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/blocs/issue_info_bloc/issue_bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

class AppBlocProvider {
  List<RepositoryProvider> getAllBlockProvider(
          UserRepository userRepository,
          FcmRepository fcmRepository,
          DeviceInfoRepository deviceInfoRepository,
          IssueRepository issueRepository) =>
      [
        RepositoryProvider<FirebaseMessagingBloc>(
            create: (context) => FirebaseMessagingBloc(
                fcmRepository: fcmRepository,
                deviceInfoRepository: deviceInfoRepository,
                userRepository: userRepository,
                issueRepository: issueRepository)),
        RepositoryProvider<UserVerificationBloc>(
            create: (context) => UserVerificationBloc(
                userRepository: userRepository,
                fcmRepository: fcmRepository,
                deviceInfoRepository: deviceInfoRepository)),
        RepositoryProvider<EmployeeVerificationBloc>(
          create: (context) =>
              EmployeeVerificationBloc(userRepository: userRepository),
        ),
        RepositoryProvider<HomeBloc>(
          create: (context) => HomeBloc(
              userRepository: userRepository,
              deviceInfoRepository: deviceInfoRepository,
              fcmRepository: fcmRepository),
        ),
        RepositoryProvider<IssueBloc>(
          create: (context) => IssueBloc(issueRepository: issueRepository),
        ),
      ];

  static final AppBlocProvider _singleton = AppBlocProvider._();

  factory AppBlocProvider() => _singleton;

  AppBlocProvider._();
}
