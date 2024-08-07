import 'package:flix_id/data/firebase/firebase_user_repository.dart';
import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/transaction.dart';

import "package:cloud_firestore/cloud_firestore.dart" as firestore;

class FirebaseTransactionRepository implements TransactionRepository {
  final firestore.FirebaseFirestore _firestore;

  FirebaseTransactionRepository(
      {firestore.FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? firestore.FirebaseFirestore.instance;

  @override
  Future<Result<Transaction>> createTransaction(
      {required Transaction transaction}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firestore.collection("transactions");

    var userRepository = FirebaseUserRepository();
    try {
      var balanceResult =
          await userRepository.getUserBalance(uid: transaction.uid);

      if (balanceResult.isFailed) {
        return const Result.failed("Failed to create transaction");
      }

      int currentBalance = balanceResult.resultValue ?? 0;
      int newbalance = currentBalance - transaction.totalPrice;
      if (newbalance < 0) {
        return const Result.failed(
            "Failed to create transaction, not enough balance");
      }

      // create transaction data
      await transactions.doc(transaction.id).set(transaction.toJson());

      var newTransaction = await transactions.doc(transaction.id).get();
      if (!newTransaction.exists) {
        return const Result.failed("Failed to create transaction");
      }

      var updateBalanceResult = await userRepository.updateUserBalance(
          uid: transaction.uid, balance: newbalance);
      if (updateBalanceResult.isFailed) {
        return const Result.failed("Failed to create transaction");
      }

      return Result.success(Transaction.fromJson(newTransaction.data()!));
    } on firestore.FirebaseException catch (e) {
      return const Result.failed("Failed to create transaction");
    }
  }

  @override
  Future<Result<List<Transaction>>> getUserTransactions(
      {required String uid}) async {
    firestore.CollectionReference<Map<String, dynamic>> transactions =
        _firestore.collection("transactions");
    try {
      var result = await transactions.where("uid", isEqualTo: uid).get();

      if (result.docs.isEmpty) {
        return const Result.success([]);
      }

      return Result.success(
          result.docs.map((e) => Transaction.fromJson(e.data())).toList());
    } catch (e) {
      return const Result.failed("Failed to get user transaction");
    }
  }
}
