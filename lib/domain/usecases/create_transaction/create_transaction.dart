import 'package:flix_id/data/repositories/transaction_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/transaction.dart';
import 'package:flix_id/domain/usecases/create_transaction/create_transaction_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class CreateTransaction
    implements Usecase<Result<void>, CreateTransactionParams> {
  final TransactionRepository _transactionRepository;

  CreateTransaction({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;

  @override
  Future<Result<void>> call(CreateTransactionParams params) async {
    int transactionTime = DateTime.now().millisecond;
    String trxId = params.transaction.id ??
        "flx-$transactionTime-${params.transaction.uid}";

    final result = await _transactionRepository.createTransaction(
        transaction: params.transaction
            .copyWith(transactionTime: transactionTime, id: trxId));

    if (result.isSuccess) {
      return const Result.success(null);
    }

    return Result.failed(result.errorMessage!);
  }
}
