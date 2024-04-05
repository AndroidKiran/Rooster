import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rooster/blocs/form_verification_bloc/form_verification_bloc.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_state.dart';
import 'package:rooster/blocs/user_verification_bloc/user_verification_bloc.dart';
import 'package:rooster/data_stores/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster/screens/routes/rooster_router.dart';

class RoosterApp extends StatelessWidget {
  final UserRepository userRepository;

  const RoosterApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserVerificationBloc>(
            create: (context) => UserVerificationBloc(userRepository: userRepository)
        ),
        RepositoryProvider(
          create: (context) => FormVerificationBloc(userRepository: userRepository),
        ),
      ],
      child: BlocListener<UserVerificationBloc, UserVerificationState>(
        listener: (context, state) {
          RoosterRouter.router.refresh();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: RoosterRouter.router.routeInformationParser,
          routerDelegate: RoosterRouter.router.routerDelegate,
          routeInformationProvider: RoosterRouter.router.routeInformationProvider,
        ),
      ),
    );
  }
}