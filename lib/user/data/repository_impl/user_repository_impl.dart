import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../../core/error/result.dart';
import '../../../core/utils/exception_mapper.dart';
import '../data_source/user_data_source.dart';
import '../dto/user_dto.dart';
import '../mapper/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;

  UserRepositoryImpl({required UserDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<User>> getUser(String userId) async {
    try {
      final data = await _dataSource.fetchUserData(userId);
      final dto = UserDto.fromJson(data);
      final user = dto.toModel();
      return Success(user); // ← 수정! Result.success() → Success()
    } catch (e, st) {
      return Error(
        mapExceptionToFailure(e, st),
      ); // ← 수정! Result.error() → Error()
    }
  }

  @override
  Future<Result<List<User>>> getUserList() async {
    try {
      final dataList = await _dataSource.fetchUserList();
      final dtoList = dataList.map((e) => UserDto.fromJson(e)).toList();
      final users = dtoList.toModelList();
      return Success(users); // ← 수정!
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st)); // ← 수정!
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    try {
      final dto = user.toDto();
      await _dataSource.updateUserData(user.id.toString(), dto.toJson());
      return const Success(null); // ← 수정!
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st)); // ← 수정!
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      await _dataSource.deleteUser(userId);
      return const Success(null); // ← 수정!
    } catch (e, st) {
      return Error(mapExceptionToFailure(e, st)); // ← 수정!
    }
  }
}
