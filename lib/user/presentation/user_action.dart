import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_action.freezed.dart';

@freezed
sealed class UserAction with _$UserAction {
  const factory UserAction.onLoadUser(String userId) = OnLoadUser;
  const factory UserAction.onLoadUserList() = OnLoadUserList;
  const factory UserAction.onTapUser(int userId) = OnTapUser;
  const factory UserAction.onRefresh() = OnRefresh;
}
