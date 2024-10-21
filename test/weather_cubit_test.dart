import 'package:bloc_test/bloc_test.dart';
import 'package:dvt_weather/weather/cubit/weather_cubit.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dvt_weather/services/location_service.dart';
import 'package:dvt_weather/services/remote_config_service.dart';
import 'package:open_weather_api/open_weather_api.dart';

import 'constants.dart';

class MockLocationService extends Mock implements LocationService {}

class MockRemoteConfigService extends Mock implements RemoteConfigService {}

class MockOpenWeatherClient extends Mock implements OpenWeatherClient {}

class MockLocationData extends Mock implements LocationData {
  @override
  double get latitude => 1.0;

  @override
  double get longitude => 1.0;
}

void main() {
  group('WeatherCubit', () {
    late MockLocationService mockLocationService;
    late MockRemoteConfigService mockRemoteConfigService;
    late MockOpenWeatherClient mockOpenWeatherClient;
    late WeatherCubit weatherCubit;

    setUp(() {
      mockLocationService = MockLocationService();
      mockRemoteConfigService = MockRemoteConfigService();
      mockOpenWeatherClient = MockOpenWeatherClient();
      weatherCubit = WeatherCubit(
        locationService: mockLocationService,
        remoteConfig: mockRemoteConfigService,
        client: mockOpenWeatherClient,
      );
    });

    test('initial state is WeatherState.initial', () {
      expect(weatherCubit.state, const WeatherState.initial());
    });

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState.fetching, WeatherState.fetched] when getWeather succeeds',
      setUp: () {
        when(() => mockLocationService.getLocation())
            .thenAnswer((_) async => MockLocationData());
        when(() => mockRemoteConfigService.getString(key: any(named: 'key')))
            .thenAnswer((_) async => 'testApiKey');
        when(() => mockOpenWeatherClient.getWeather(
                  lat: 1.0,
                  lon: 1.0,
                  apiKey: 'testApiKey',
                ))
            .thenAnswer(
                (_) async => WeatherData.fromJson(Constants().successfulData));
      },
      build: () => weatherCubit,
      act: (cubit) => cubit.getWeather(),
      expect: () => [
        isA<WeatherState>().having(
          (w) => w.maybeWhen(
            fetching: () => true,
            orElse: () => false,
          ),
          'state is fetching',
          true,
        ),
        isA<WeatherState>().having(
          (w) => w.maybeWhen(
            fetched: (_) => true,
            orElse: () => false,
          ),
          'state is fetched',
          true,
        ),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState.fetching, WeatherState.error] when location service fails',
      setUp: () {
        when(() => mockLocationService.getLocation())
            .thenThrow(Exception('Location Error'));
      },
      build: () => weatherCubit,
      act: (cubit) => cubit.getWeather(),
      expect: () => [
        const WeatherState.fetching(),
        const WeatherState.error('Exception: Location Error'),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState.fetching, WeatherState.error] when remote config fails',
      setUp: () {
        when(() => mockLocationService.getLocation())
            .thenAnswer((_) async => MockLocationData());
        when(() => mockRemoteConfigService.getString(key: any(named: 'key')))
            .thenThrow(Exception('Remote Config Error'));
      },
      build: () => weatherCubit,
      act: (cubit) => cubit.getWeather(),
      expect: () => [
        const WeatherState.fetching(),
        const WeatherState.error('Exception: Remote Config Error'),
      ],
    );

    blocTest<WeatherCubit, WeatherState>(
      'emits [WeatherState.fetching, WeatherState.error] when weather API fails',
      setUp: () {
        when(() => mockLocationService.getLocation())
            .thenAnswer((_) async => MockLocationData());
        when(() => mockRemoteConfigService.getString(key: any(named: 'key')))
            .thenAnswer((_) async => 'testApiKey');
        when(() => mockOpenWeatherClient.getWeather(
              lat: any(named: 'lat'),
              lon: any(named: 'lon'),
              apiKey: any(named: 'apiKey'),
            )).thenThrow(Exception('Weather API Error'));
      },
      build: () => weatherCubit,
      act: (cubit) => cubit.getWeather(),
      expect: () => [
        const WeatherState.fetching(),
        const WeatherState.error('Exception: Weather API Error'),
      ],
    );

    tearDown(() {
      weatherCubit.close();
    });
  });
}