import 'package:hd_images/features/auth/domain/models/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity?> signUpWithEmailAndPassword(String email, String password);
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
}
