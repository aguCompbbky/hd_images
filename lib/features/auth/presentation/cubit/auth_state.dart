import 'package:hd_images/features/auth/domain/models/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user);
  final UserEntity user;
}

class AuthError extends AuthState {
  AuthError(this.message);
  final String message;
}
