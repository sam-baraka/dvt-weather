import 'package:dvt_weather/services/location_service.dart';
import 'package:dvt_weather/services/remote_config_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:open_weather_api/open_weather_api.dart';

part 'weather_state.dart';
part 'weather_cubit.freezed.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({
    OpenWeatherClient? client,
    LocationService? locationService,
    RemoteConfigService? remoteConfig,
  })  : client = client ?? OpenWeatherClient(),
        locationService = locationService ?? LocationService(),
        remoteConfig = remoteConfig ?? RemoteConfigService(),
        super(const WeatherState.initial());

  final OpenWeatherClient client;
  final LocationService locationService;
  final RemoteConfigService remoteConfig;

  Future<void> getWeather() async {
    emit(const WeatherState.fetching());
    try {
      final location = await locationService.getLocation();
      String apiKey = await remoteConfig.getString(key: 'WeatherAPIKey');
      final weatherResult = await client.getWeather(
        lat: location.latitude,
        lon: location.longitude,
        apiKey: apiKey,
      );
      emit(WeatherState.fetched(weatherResult));
    } catch (e) {
      emit(WeatherState.error(e.toString()));
    }
  }
}
