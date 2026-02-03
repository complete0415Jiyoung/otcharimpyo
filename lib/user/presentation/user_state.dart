import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../weather/domain/model/weather.dart';
import '../domain/model/user.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default(AsyncValue.loading()) AsyncValue<User> userResult,
    @Default(AsyncValue.loading()) AsyncValue<List<User>> userListResult,
    @Default(null) double? latitude,
    @Default(null) double? longitude,
    @Default(null) Weather? weather,
  }) = _UserState;
}
