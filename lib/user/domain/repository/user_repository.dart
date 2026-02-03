import '../model/user.dart';
import '../../../core/error/result.dart';

abstract interface class UserRepository {
  Future<Result<User>> getUser(String userId);
  Future<Result<List<User>>> getUserList();
  Future<Result<void>> updateUser(User user);
  Future<Result<void>> deleteUser(String userId);
}
