import 'package:hd_images/features/auth/domain/models/user_entity.dart';
import 'package:hd_images/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {

  RegisterUsecase(this.repository);
  final AuthRepository repository;

  Future<UserEntity?> call(String email, String password) {
    return repository.signUpWithEmailAndPassword(email, password);
  }
}

