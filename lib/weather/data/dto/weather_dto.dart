import 'package:json_annotation/json_annotation.dart';

part 'weather_dto.g.dart';

@JsonSerializable(createToJson: false)
class WeatherDto {
  final WeatherMainDto? main;
  final List<WeatherInfoDto>? weather;
  final WeatherRainDto? rain;

  WeatherDto({this.main, this.weather, this.rain});

  factory WeatherDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class WeatherMainDto {
  final double? temp;

  @JsonKey(name: 'feels_like')
  final double? feelsLike;

  final int? humidity;

  WeatherMainDto({this.temp, this.feelsLike, this.humidity});

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

@JsonSerializable(createToJson: false)
class WeatherRainDto {
  @JsonKey(name: '1h')
  final double? oneHour;

  WeatherRainDto({this.oneHour});

  factory WeatherRainDto.fromJson(Map<String, dynamic> json) =>
      _$WeatherRainDtoFromJson(json);
}
