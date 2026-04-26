import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hd_images/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:hd_images/features/auth/domain/usecases/login_usecase.dart';
import 'package:hd_images/features/auth/domain/usecases/register_usecase.dart';
import 'package:hd_images/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit({
    required this.loginUsecase,
    required this.googleLoginUsecase,
    required this.registerUsecase,
  }) : super(AuthInitial());
  final LoginUsecase loginUsecase;
  final GoogleLoginUsecase googleLoginUsecase;
  final RegisterUsecase registerUsecase;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        debugPrint('AuthCubit -> AuthError (login): Giriş başarısız.');
        emit(AuthError('Giriş başarısız.'));
      }
    } catch (e) {
      debugPrint('AuthCubit -> AuthError (login): $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> googleLogin() async {
    emit(AuthLoading());
    try {
      final user = await googleLoginUsecase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        debugPrint('AuthCubit -> AuthError (googleLogin): Google ile giriş başarısız.');
        emit(AuthError('Google ile giriş başarısız.'));
      }
    } catch (e) {
      debugPrint('AuthCubit -> AuthError (googleLogin): $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        debugPrint('AuthCubit -> AuthError (register): Kayıt başarısız.');
        emit(AuthError('Kayıt başarısız.'));
      }
    } catch (e) {
      debugPrint('AuthCubit -> AuthError (register): $e');
      emit(AuthError(e.toString()));
    }
  }
}
