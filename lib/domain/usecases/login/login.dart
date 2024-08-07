import 'package:flix_id/data/repositories/authentication.dart';
import 'package:flix_id/data/repositories/user_repository.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/user.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

part 'login_params.dart';

class Login implements Usecase<Result<User>, LoginParams> {
  final Authentication authentication;
  final UserRepository userRepository;

  Login({required this.authentication, required this.userRepository});

  @override
  Future<Result<User>> call(LoginParams params) async {
    var result = await authentication.login(
        email: params.email, password: params.password);

    if (result is Success) {
      var user = await userRepository.getUser(uid: result.resultValue!);

      return switch (user) {
        Success(value: final user) => Result.success(user),
        Failed(:final message) => Result.failed(message)
      };
    }

    return Result.failed(result.errorMessage!);
  }
}
