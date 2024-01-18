import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/pages/home_page.dart';
import 'package:firebase_auth_bloc/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/ ';
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('splash: auth status changed');
        if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName,
              (route) {
            print('route.settings.name: ${route.settings.name}');
            print('modalRoute: ${ModalRoute.of(context)!.settings.name}');

            final routeTo = route.settings.name;
            final currentRoute = ModalRoute.of(context)!.settings.name;

            return routeTo == currentRoute;
          });
        } else if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushNamed(context, SigninPage.routeName);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
