import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'package:booknow/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

enum AuthMode { signIn, signUp }

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.mode});
  final AuthMode mode;

  static Route<void> route(AuthMode mode) =>
      MaterialPageRoute(builder: (_) => AuthPage(mode: mode));

  @override
  Widget build(BuildContext context) {
    final isSignIn = mode == AuthMode.signIn;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/0.png', height: 28),
            const SizedBox(width: 8),
            Text(isSignIn ? 'Sign In' : 'Sign Up'),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: isSignIn
                ? BlocProvider<SignInBloc>(
                    create: (ctx) =>
                        SignInBloc(ctx.read<AuthenticationBloc>().userRepository),
                    child: const SignInScreen(),
                  )
                : BlocProvider<SignUpBloc>(
                    create: (ctx) =>
                        SignUpBloc(ctx.read<AuthenticationBloc>().userRepository),
                    child: const SignUpScreen(),
                  ),
          ),
        ),
      ),
    );
  }
}
