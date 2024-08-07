import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/domain/entities/result.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class FirebaseAuthentication implements Authentication {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthentication({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  String? getLoggedInUserId() => _firebaseAuth.currentUser?.uid;

  @override
  Future<Result<String>> login(
      {required String email, required String password}) async {
    try {
      var res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Result.success(res.user?.uid ?? "");
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failed(e.message!);
    }
  }

  @override
  Future<Result<void>> logout() async {
    await _firebaseAuth.signOut();
    if (_firebaseAuth.currentUser == null) {
      return const Result.success(null);
    }

    return const Result.failed("Failed to log out");
  }

  @override
  Future<Result<String>> register(
      {required String email, required String password}) async {
    try {
      var userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Result.success(userCredentials.user?.uid ?? "");
    } on firebase_auth.FirebaseAuthException catch (e) {
      return const Result.failed("Failed to register");
    }
  }
}
