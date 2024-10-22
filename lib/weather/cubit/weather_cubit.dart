import 'package:dvt_weather/services/location_service.dart';
import 'package:dvt_weather/services/remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:place_search/place_search.dart';

part 'weather_state.dart';
part 'weather_cubit.freezed.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({
    OpenWeatherClient? client,
    SearchPlaceClient? searchPlaceClient,
    LocationService? locationService,
    RemoteConfigService? remoteConfig,
  })  : client = client ?? OpenWeatherClient(),
        locationService = locationService ?? LocationService(),
        remoteConfig = remoteConfig ?? RemoteConfigService(),
        searchPlaceClient = searchPlaceClient ?? SearchPlaceClient(),
        super(const WeatherState.initial());

  final OpenWeatherClient client;
  final LocationService locationService;
  final RemoteConfigService remoteConfig;
  final SearchPlaceClient searchPlaceClient;

  Future<void> searchPlace({required String name}) async {
    emit(const WeatherState.fetching());
    try {
      var place = await searchPlaceClient.getPlace(
        name: name,
        apiKey: await remoteConfig.getString(key: 'PlacesAPIKey'),
      );
      emit(WeatherState.searchedPlace(place));
    } catch (e) {
      emit(WeatherState.error(e.toString()));
    }
  }

  Future<void> getWeather({Place? place}) async {
    emit(const WeatherState.fetching());
    try {
      if (place != null) {
        final weatherResult = await client.getWeather(
          lat: place.places[0].location.latitude,
          lon: place.places[0].location.longitude,
          apiKey: await remoteConfig.getString(key: 'WeatherAPIKey'),
        );
        emit(WeatherState.fetched(weatherResult));
        return;
      } else {
        final location = await locationService.getLocation();
        String apiKey = await remoteConfig.getString(key: 'WeatherAPIKey');
        final weatherResult = await client.getWeather(
          lat: location.latitude,
          lon: location.longitude,
          apiKey: apiKey,
        );
        emit(WeatherState.fetched(weatherResult));
      }
    } catch (e) {
      emit(WeatherState.error(e.toString()));
    }
  }
}
