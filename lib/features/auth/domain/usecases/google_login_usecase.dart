import 'package:hd_images/features/auth/domain/models/user_entity.dart';
import 'package:hd_images/features/auth/domain/repositories/auth_repository.dart';

class GoogleLoginUsecase {

  GoogleLoginUsecase(this.repository);
  final AuthRepository repository;

  Future<UserEntity?> call() {
    return repository.signInWithGoogle();
  }
}
