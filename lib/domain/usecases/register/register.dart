import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/user.dart';
import 'package:flix_id/domain/usecases/register/register_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class Register implements Usecase<Result<User>, RegisterParams> {
  final Authentication _authentication;
  final UserRepository _userRepository;

  Register(
      {required Authentication authentication,
      required UserRepository userRepository})
      : _authentication = authentication,
        _userRepository = userRepository;

  @override
  Future<Result<User>> call(RegisterParams params) async {
    final registeredUid = await _authentication.register(
        email: params.email, password: params.password);

    if (registeredUid.isFailed) {
      return Result.failed(registeredUid.errorMessage!);
    }

    final uid = registeredUid.resultValue!;

    final newUserResult = await _userRepository.createUser(
        uid: uid,
        email: params.email,
        name: params.name,
        photoUrl: params.photoUrl);

    if (newUserResult.isFailed) {
      return Result.failed(newUserResult.errorMessage!);
    }

    return Result.success(newUserResult.resultValue!);
  }
}
