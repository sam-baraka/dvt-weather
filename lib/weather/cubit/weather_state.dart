part of 'weather_cubit.dart';

@freezed
class WeatherState with _$WeatherState {
    const factory WeatherState.initial() = _Initial;
  const factory WeatherState.fetching() = _Fetching;
  const factory WeatherState.fetched(WeatherData weather) = _Fetched;
  const factory WeatherState.error(String message) = _Error;
}
