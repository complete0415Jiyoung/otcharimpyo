import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required double temp,
    required String description,
    required String icon,

    required double feelsLike, // 체감온도
    required int humidity, // 습도 (%)
    required double precipitation, // 강수량 (mm)
  }) = _Weather;
}
