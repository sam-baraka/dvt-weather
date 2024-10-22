import 'package:dio/dio.dart';
import 'package:place_search/src/models/place.dart';
import 'package:shared_utils/shared_utils.dart';

class SearchPlaceClient {
  SearchPlaceClient({RestClient? restClient})
      : _restClient = restClient ?? RestClient();

  final RestClient _restClient;

  Future<Place> getPlace({required String name, required String apiKey}) async {
    try {
      const String url = 'https://places.googleapis.com/v1/places:searchText';
      var response = await _restClient.dio.post(url,
          data: {"textQuery": name},
          options: Options(headers: {
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask':
                'places.name,places.location,places.addressComponents.shortText'
          }));
      return Place.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('${e.response?.data['message']}');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
