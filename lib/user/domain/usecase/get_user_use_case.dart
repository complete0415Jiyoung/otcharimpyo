import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../../../core/error/result.dart';
import '../../../core/error/failure.dart'; // ← 이 줄 있는지 확인!

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<AsyncValue<User>> execute(String userId) async {
    try {
      final result = await _repository.getUser(userId);

      if (result is Success<User>) {
        return AsyncValue.data((result).value);
      } else if (result is Error<User>) {
        final error = result;
        return AsyncValue.error(
          error.failure,
          error.failure.stackTrace ?? StackTrace.current,
        );
      } else {
        return AsyncValue.error(
          Exception('Unknown result type'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      return AsyncValue.error(e, st);
    }
  }
}
