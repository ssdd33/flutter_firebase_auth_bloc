import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_auth_bloc/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authSubscription;
  final AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.unknown()) {
    authSubscription = authRepository.user.listen((fbAuth.User? user) {
      print('from fb user stream: $user');
      add(AuthStateChangeEvent(user: user));
    });

    on<AuthStateChangeEvent>((event, emit) {
      print('authChangeEvent: ${event.user}');
      if (event.user != null) {
        emit(state.copyWith(
            user: event.user, authStatus: AuthStatus.authenticated));
      } else {
        print('emit changed authstate');
        emit(
            state.copyWith(user: null, authStatus: AuthStatus.unauthenticated));
      }
    });

    on<SignoutRequestedEvent>((event, emit) {
      authRepository.signout();
    });
  }
}
