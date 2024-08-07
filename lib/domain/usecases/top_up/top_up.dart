import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/transaction.dart';
import 'package:flix_id/domain/usecases/create_transaction/create_transaction.dart';
import 'package:flix_id/domain/usecases/create_transaction/create_transaction_params.dart';

import 'package:flix_id/domain/usecases/top_up/top_up_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class TopUp implements Usecase<Result<void>, TopUpParams> {
  final TransactionRepository _transactionRepository;

  TopUp({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  @override
  Future<Result<void>> call(TopUpParams params) async {
    CreateTransaction createTransaction =
        CreateTransaction(transactionRepository: _transactionRepository);

    int transactionTime = DateTime.now().millisecond;
    final transaction = Transaction(
        uid: params.uid,
        title: "Top Up",
        id: "flxtp-$transactionTime-${params.uid}",
        adminFee: 0,
        transactionTime: transactionTime,
        totalPrice: -params.amount);

    final result = await createTransaction
        .call(CreateTransactionParams(transaction: transaction));

    return result;
  }
}
