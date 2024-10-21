import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:open_weather_api/src/models/weather.dart';
import 'package:open_weather_api/src/utilities/rest_client.dart';
import 'package:open_weather_api/src/open_weather_client.dart';

import 'constants.dart';

class MockRestClient extends Mock implements RestClient {}

class MockDio extends Mock implements Dio {}

class MockSuccessResponse extends Mock implements Response {
  @override
  int? get statusCode => 200;

  @override
  get data => Constants().successfulData;
}

class MockFailedResponse extends Mock implements Response {
  @override
  int? get statusCode => 400;

  @override
  get data => Constants().failedData;
}

void main() {
  late MockRestClient mockRestClient;
  late MockDio mockDio;
  late OpenWeatherClient client;

  setUp(() {
    mockRestClient = MockRestClient();
    mockDio = MockDio();
    when(() => mockRestClient.dio).thenReturn(mockDio);
    client = OpenWeatherClient(restClient: mockRestClient);
  });

  group('OpenWeatherClientTest', () {
    const double lat = 51.5074;
    const double lon = -0.1278;
    const String apiKey = 'test-api-key';
    const url = 'https://api.openweathermap.org/data/3.0/onecall';

    test('getWeather returns Weather object on successful response', () async {
      // Arrange
      final mockResponse = MockSuccessResponse();

      when(() => mockDio.get(
            url,
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await client.getWeather(
        lat: lat,
        lon: lon,
        apiKey: apiKey,
      );

      // Assert
      expect(result, isA<WeatherData>());
      verify(() => mockDio.get(
            url,
            queryParameters: {
              'lat': lat,
              'lon': lon,
              'appid': apiKey,
              'units': 'metric',
              'exclude': 'minutely,hourly',
            },
          )).called(1);
    });

    test('getWeather throws Exception on DioException', () async {
      // Arrange
      when(() => mockDio.get(
            url,
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: url),
          response: Response(
            requestOptions: RequestOptions(path: url),
            data: {'message': 'Invalid API key'},
            statusCode: 401,
          ),
          message: 'Request failed',
        ),
      );

      // Act & Assert
      expect(
        () => client.getWeather(
          lat: lat,
          lon: lon,
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getWeather validates latitude range', () async {
      // Act & Assert
      expect(
        () => client.getWeather(
          lat: 91, // Invalid latitude
          lon: lon,
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );

      expect(
        () => client.getWeather(
          lat: -91, // Invalid latitude
          lon: lon,
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getWeather validates longitude range', () async {
      // Act & Assert
      expect(
        () => client.getWeather(
          lat: lat,
          lon: 181, // Invalid longitude
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );

      expect(
        () => client.getWeather(
          lat: lat,
          lon: -181, // Invalid longitude
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getWeather validates apiKey is not empty', () async {
      // Act & Assert
      expect(
        () => client.getWeather(
          lat: lat,
          lon: lon,
          apiKey: '', // Empty API key
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
