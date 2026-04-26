import 'package:hd_images/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:hd_images/features/auth/domain/models/user_entity.dart';
import 'package:hd_images/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({required this.remoteDataSource});
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password) {
    return remoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword(String email, String password) {
    return remoteDataSource.signUpWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity?> signInWithGoogle() {
    return remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}
