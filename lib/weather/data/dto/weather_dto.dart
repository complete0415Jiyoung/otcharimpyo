import 'package:json_annotation/json_annotation.dart';

part 'weather_dto.g.dart';

@JsonSerializable(createToJson: false)
class WeatherDto {
  final WeatherMainDto? main;
  final List<WeatherInfoDto>? weather;

  WeatherDto({this.main, this.weather});

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherMainDto {
  final double? temp;

  WeatherMainDto({this.temp});

  factory WeatherMainDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherMainDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherInfoDto {
  final String? description;
  final String? icon;

  WeatherInfoDto({this.description, this.icon});

  factory WeatherInfoDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoDtoFromJson(json);
}
