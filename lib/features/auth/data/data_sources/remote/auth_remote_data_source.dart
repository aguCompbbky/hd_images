import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hd_images/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });
  final FirebaseAuth firebaseAuth;

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      debugPrint('Error signInWithEmailAndPassword: $e');
      throw Exception('Giriş başarısız');
    }
    return null;
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      debugPrint('Error signUpWithEmailAndPassword: $e');
      throw Exception('Kayıt başarısız');
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      // google_sign_in v7 API
      await GoogleSignIn.instance.initialize();
      
      final googleUser =
          await GoogleSignIn.instance.authenticate();

      // v7.2.0'da idToken GoogleSignInAuthentication üzerinden alınıyor
      final googleAuth =
          googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('Google ID token alınamadı');

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      debugPrint('Error signInWithGoogle: $e');
      throw Exception('Google ile giriş başarısız');
    }
    return null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
