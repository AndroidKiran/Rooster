import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/blocs/add_employee_verification_bloc/add_employee_verification_bloc.dart';
import 'package:rooster/blocs/firebase_messaging_bloc/firebase_messaging_bloc.dart';
import 'package:rooster/blocs/home_bloc/home_bloc.dart';
import 'package:rooster/blocs/issue_info_bloc/issue_bloc.dart';
import 'package:rooster/blocs/user_authentication_bloc/user_authentication_bloc.dart';
import 'package:rooster/blocs/user_info_block/user_info_bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/data_stores/repositories/device_info_repo/device_info_repository.dart';
import 'package:rooster/data_stores/repositories/fcm_repo/fcm_repository.dart';
import 'package:rooster/data_stores/repositories/issue_repo/issue_repository.dart';
import 'package:rooster/data_stores/repositories/user_repo/user_repository.dart';

/// A central provider for BLoC (Business Logic Component) instances
/// in a Flutter application.
///
/// This class acts asa singleton, providing a list of
/// [RepositoryProvider] widgets that create and manage the lifecycle
/// of various BLoCs, ensuring they have access to necessary
/// repositories.

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
            create: (context) =>
                UserVerificationBloc(userRepository: userRepository)),
        RepositoryProvider<UserAuthenticationBloc>(
          create: (context) =>
              UserAuthenticationBloc(userRepository: userRepository),
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
        RepositoryProvider<UserInfoBloc>(
          create: (context) => UserInfoBloc(userRepository: userRepository),
        ),
        RepositoryProvider<AddEmployeeVerificationBloc>(
          create: (context) =>
              AddEmployeeVerificationBloc(userRepository: userRepository),
        ),
      ];

  static final AppBlocProvider _singleton = AppBlocProvider._();

  factory AppBlocProvider() => _singleton;

  AppBlocProvider._();
}
