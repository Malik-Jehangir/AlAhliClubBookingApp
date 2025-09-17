import 'package:booknow/app_view.dart';
import 'package:booknow/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository; //for the app to access the user repository
  const MyApp(this.userRepository,{super.key}); //also added in the constructor


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc( //authentication bloc will take userRespository as a parameter and MyAppView as child parameter
        userRepository: userRepository
      ),
      child: MyAppView(),
      );
  }
}