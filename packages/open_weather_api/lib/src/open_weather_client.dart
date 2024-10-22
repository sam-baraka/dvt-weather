
import 'package:dio/dio.dart';
import 'package:open_weather_api/src/models/weather.dart';
import 'package:shared_utils/shared_utils.dart';

class OpenWeatherClient {
  OpenWeatherClient({RestClient? restClient})
      : _restClient = restClient ?? RestClient();

  final RestClient _restClient;

  Future<WeatherData> getWeather(
      {required double? lat,
      required double? lon,
      required String apiKey}) async {
    try {
      const String url = 'https://api.openweathermap.org/data/3.0/onecall';
      var response = await _restClient.dio.get(url, queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
        'exclude': 'minutely,hourly'
      });
      return WeatherData.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${e.response?.data['message']}');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
