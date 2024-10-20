import 'package:dio/dio.dart';
import 'package:open_weather_api/src/models/weather.dart';
import 'package:open_weather_api/src/utilities/rest_client.dart';

class OpenWeatherClient {
  final RestClient restClient;

  OpenWeatherClient({required this.restClient});

  Future<Weather> getWeather(
      {required double lat,
      required double lon,
      required String apiKey}) async {
    try {
      const String url = 'https://api.openweathermap.org/data/3.0/onecall';
      var response = await restClient.dio.get(url, queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': 'metric',
      });
      return Weather.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${e.message}: ${e.response?.data['message']}');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
