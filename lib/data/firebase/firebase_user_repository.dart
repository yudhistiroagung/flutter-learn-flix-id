import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<User>> createUser(
      {required String uid,
      required String email,
      required String name,
      String? photoUrl,
      int balance = 0}) async {
    CollectionReference<Map<String, dynamic>> users =
        _firestore.collection("users");

    await users.doc(uid).set({
      "uid": uid,
      "email": email,
      "name": name,
      "balance": balance,
      "photoUrl": photoUrl
    });

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await users.doc(uid).get();
    if (snapshot.exists) {
      return Result.success(User.fromJson(snapshot.data()!));
    }

    return const Result.failed("Failed to create user");
  }

  @override
  Future<Result<User>> getUser({required String uid}) async {
    DocumentReference<Map<String, dynamic>> reference =
        _firestore.doc("users/$uid");

    DocumentSnapshot<Map<String, dynamic>> snapshot = await reference.get();
    if (snapshot.exists) {
      return Result.success(User.fromJson(snapshot.data()!));
    }

    return Result.failed("User with $uid not found");
  }

  @override
  Future<Result<int>> getUserBalance({required String uid}) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firestore.doc("users/$uid");

      DocumentSnapshot<Map<String, dynamic>> snapshot = await reference.get();
      if (!snapshot.exists) {
        return const Result.failed(
            "Failed to get user balance, user not found");
      }

      return Result.success(snapshot.data()?["balance"] ?? 0);
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? "Failed to update user balance");
    }
  }

  @override
  Future<Result<User>> updateUser({required User user}) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firestore.doc("users/${user.uid}");

      await reference.update(user.toJson());

      var result = await reference.get();
      if (!result.exists) {
        return const Result.failed("Failed to update user");
      }

      User updatedUser = User.fromJson(result.data()!);
      if (updatedUser == user) {
        return Result.success(updatedUser);
      }

      return const Result.failed("Failed to update user");
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? "Failed to update user");
    }
  }

  @override
  Future<Result<User>> updateUserBalance(
      {required String uid, required int balance}) async {
    try {
      DocumentReference<Map<String, dynamic>> reference =
          _firestore.doc("users/$uid");

      DocumentSnapshot<Map<String, dynamic>> snapshot = await reference.get();
      if (!snapshot.exists) {
        return const Result.failed(
            "Failed to update user balance, user not found");
      }

      await reference.update({"balance": balance});

      DocumentSnapshot<Map<String, dynamic>> updated = await reference.get();
      if (!updated.exists) {
        return const Result.failed("Failed to retrieve updated user balance");
      }

      User updatedUser = User.fromJson(updated.data()!);
      if (updatedUser.balance == balance) {
        return Result.success(updatedUser);
      }

      return const Result.failed("Failed to update user balance");
    } on FirebaseException catch (e) {
      return Result.failed(e.message ?? "Failed to update user balance");
    }
  }

  @override
  Future<Result<User>> uploadProfilePicture(
      {required User user, required File imageFile}) async {
    String filename = basename(imageFile.path);

    Reference reference = FirebaseStorage.instance.ref().child(filename);

    try {
      await reference.putFile(imageFile);
      String url = await reference.getDownloadURL();

      var updatedUser = await updateUser(user: user.copyWith(photoUrl: url));
      if (updatedUser.isSuccess) {
        return Result.success(updatedUser.resultValue!);
      }

      return Result.failed(updatedUser.errorMessage ?? "");
    } catch (e) {
      return const Result.failed("Failed to upload profile picture");
    }
  }
}
