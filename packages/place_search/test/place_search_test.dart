import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:place_search/src/models/place.dart';
import 'package:place_search/src/search_place_client.dart';
import 'package:shared_utils/shared_utils.dart';

class MockRestClient extends Mock implements RestClient {}

class MockDio extends Mock implements Dio {}

class MockSuccessResponse extends Mock implements Response {
  @override
  int? get statusCode => 200;

  @override
  get data => {
        'places': [
          {
            'name': 'Test Place',
            'location': {'latitude': 51.5074, 'longitude': -0.1278},
            'addressComponents': [
              {'shortText': 'Test Address'}
            ]
          }
        ]
      };
}

class MockFailedResponse extends Mock implements Response {
  @override
  int? get statusCode => 400;

  @override
  get data => {'message': 'Invalid request'};
}

void main() {
  late MockRestClient mockRestClient;
  late MockDio mockDio;
  late SearchPlaceClient client;

  setUp(() {
    mockRestClient = MockRestClient();
    mockDio = MockDio();
    when(() => mockRestClient.dio).thenReturn(mockDio);
    client = SearchPlaceClient(restClient: mockRestClient);
  });

  group('SearchPlaceClientTest', () {
    const String placeName = 'Test Place';
    const String apiKey = 'test-api-key';
    const url = 'https://places.googleapis.com/v1/places:searchText';

    test('getPlace returns Place object on successful response', () async {
      // Arrange
      final mockResponse = MockSuccessResponse();

      when(() => mockDio.post(
            url,
            options: any(named: 'options'),
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await client.getPlace(
        name: placeName,
        apiKey: apiKey,
      );

      // Assert
      expect(result, isA<Place>());
      verify(() => mockDio.post(
            url,
            options: any(named: 'options', that: predicate((Options options) {
              return options.headers?['X-Goog-Api-Key'] == apiKey &&
                  options.headers?['X-Goog-FieldMask'] ==
                      'places.name,places.location,places.addressComponents.shortText';
            })),
          )).called(1);
    });

    test('getPlace throws Exception on DioException', () async {
      // Arrange
      when(() => mockDio.post(
            url,
            options: any(named: 'options'),
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
        () => client.getPlace(
          name: placeName,
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getPlace validates place name is not empty', () async {
      // Act & Assert
      expect(
        () => client.getPlace(
          name: '', // Empty place name
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getPlace validates apiKey is not empty', () async {
      // Act & Assert
      expect(
        () => client.getPlace(
          name: placeName,
          apiKey: '', // Empty API key
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getPlace handles general exceptions', () async {
      // Arrange
      when(() => mockDio.post(
            url,
            options: any(named: 'options'),
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () => client.getPlace(
          name: placeName,
          apiKey: apiKey,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}