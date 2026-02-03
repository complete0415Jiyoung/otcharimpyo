import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../../../core/error/result.dart';

class GetUserListUseCase {
  final UserRepository _repository;

  GetUserListUseCase(this._repository);

  Future<AsyncValue<List<User>>> execute() async {
    final result = await _repository.getUserList();

    return switch (result) {
      Success(:final value) => AsyncValue.data(value),
      Error(:final failure) => AsyncValue.error(
        failure,
        failure.stackTrace ?? StackTrace.current,
      ),
    };
  }
}
