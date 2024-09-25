import 'package:countryapp/controllers/auth_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthSignUpRequested) {
        emit(AuthLoading());
        try {
          await AuthController.createUserWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(AuthAuthenticated());
        } on FirebaseAuthException catch (e) {
          emit(AuthError(errorMessage: e.message!));
        }
      }

      if (event is AuthSignInRequested) {
        emit(AuthLoading());
        try {
          await AuthController.signInWithEmailAndPassword(
              email: event.email, password: event.password);
          emit(AuthAuthenticated());
        } on FirebaseAuthException catch (e) {
          emit(AuthError(errorMessage: e.message!));
        }
      }
    });
  }
}
