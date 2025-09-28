import 'package:booknow/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:booknow/screens/auth/views/welcome_screen.dart';
import 'package:booknow/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Ahli Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade200,
          onSurface: Colors.black,
          primary: const Color.fromARGB(255, 80, 5, 5),
          onPrimary: Colors.white,
          tertiary: const Color.fromARGB(255, 243, 203, 84)
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: ((context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => SignInBloc(
                context.read<AuthenticationBloc>().userRepository
              ),
              child: HomeScreen(),
            );
          } else {
            return WelcomeScreen();
          }
        }),
      ),
    );
  }
}
