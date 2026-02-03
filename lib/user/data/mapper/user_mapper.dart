import '../dto/user_dto.dart';
import '../../domain/model/user.dart';

extension UserDtoMapper on UserDto {
  User toModel() {
    return User(
      id: id?.toInt() ?? -1,
      email: email ?? '',
      username: username ?? '',
      name: name ?? '',
      phone: phone ?? '',
    );
  }
}

extension UserModelMapper on User {
  UserDto toDto() {
    return UserDto(
      id: id,
      email: email,
      username: username,
      name: name,
      phone: phone,
    );
  }
}

extension UserDtoListMapper on List<UserDto>? {
  List<User> toModelList() {
    return this?.map((dto) => dto.toModel()).toList() ?? [];
  }
}

extension UserModelListMapper on List<User> {
  List<UserDto> toDtoList() {
    return map((model) => model.toDto()).toList();
  }
}
