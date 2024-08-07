import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/user.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetLoggedInUser implements Usecase<Result<User>, void> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  GetLoggedInUser(
      {required Authentication authentication,
      required UserRepository userRepository})
      : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(void params) async {
    final loggedInResult = _authentication.getLoggedInUserId();
    if (loggedInResult == null) {
      return const Result.failed("No logged in user");
    }

    final userResult = await _userRepository.getUser(uid: loggedInResult);
    if (userResult.isSuccess) {
      return Result.success(userResult.resultValue!);
    }

    return Result.failed(userResult.errorMessage!);
  }
}
