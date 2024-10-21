import 'package:bloc_test/bloc_test.dart';
import 'package:dvt_weather/favorites/cubit/favorites_cubit.dart';
import 'package:dvt_weather/favorites/models/favorite.dart';
import 'package:dvt_weather/services/favorites_persistence_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesPersistenceService extends Mock
    implements FavoritesPersistenceService {}

class FakeFavorite extends Fake implements Favorite {}

void main() {
  group('FavoritesCubit', () {
    late MockFavoritesPersistenceService mockPersistenceService;
    late FavoritesCubit favoritesCubit;

    setUpAll(() {
      registerFallbackValue(FakeFavorite());
    });

    setUp(() {
      mockPersistenceService = MockFavoritesPersistenceService();
      favoritesCubit = FavoritesCubit(
        favoritesPersistenceService: mockPersistenceService,
      );
    });

    test('initial state is FavoritesState.initial', () {
      expect(favoritesCubit.state, const FavoritesState.initial());
    });

    group('getFavorites', () {
      final testFavorites = [
        Favorite(
          name: 'London',
          lat: 51.5074,
          lon: -0.1278,
        ),
        Favorite(
          name: 'Paris',
          lat: 48.8566,
          lon: 2.3522,
        ),
      ];

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, fetched] when getFavorites succeeds with data',
        setUp: () {
          when(() => mockPersistenceService.getFavorites())
              .thenReturn(testFavorites);
        },
        build: () => favoritesCubit,
        act: (cubit) => cubit.getFavorites(),
        expect: () => [
          const FavoritesState.loading(),
          FavoritesState.fetched(testFavorites),
        ],
        verify: (_) {
          verify(() => mockPersistenceService.getFavorites()).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, fetched] when getFavorites succeeds with empty list',
        setUp: () {
          when(() => mockPersistenceService.getFavorites()).thenReturn([]);
        },
        build: () => favoritesCubit,
        act: (cubit) => cubit.getFavorites(),
        expect: () => [
          const FavoritesState.loading(),
          const FavoritesState.fetched([]),
        ],
        verify: (_) {
          verify(() => mockPersistenceService.getFavorites()).called(1);
        },
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, error] when getFavorites throws',
        setUp: () {
          when(() => mockPersistenceService.getFavorites())
              .thenThrow(Exception('Storage error'));
        },
        build: () => favoritesCubit,
        act: (cubit) => cubit.getFavorites(),
        expect: () => [
          const FavoritesState.loading(),
          const FavoritesState.error('Exception: Storage error'),
        ],
        verify: (_) {
          verify(() => mockPersistenceService.getFavorites()).called(1);
        },
      );
    });

    group('saveFavorites', () {
      final testFavorites = [
        Favorite(
          name: 'Tokyo',
          lat: 35.6762,
          lon: 139.6503,
        ),
      ];

      test('calls persistence service with correct data', () {
        when(() => mockPersistenceService.saveFavorites(any()))
            .thenReturn(null);

        favoritesCubit.saveFavorites(testFavorites);

        verify(() => mockPersistenceService.saveFavorites(testFavorites))
            .called(1);
      });

      test('handles empty list', () {
        when(() => mockPersistenceService.saveFavorites(any()))
            .thenReturn(null);

        favoritesCubit.saveFavorites([]);

        verify(() => mockPersistenceService.saveFavorites([])).called(1);
      });

      test('handles persistence service errors', () {
        when(() => mockPersistenceService.saveFavorites(any()))
            .thenThrow(Exception('Storage error'));

        expect(
          () => favoritesCubit.saveFavorites(testFavorites),
          throwsException,
        );
      });
    });

    tearDown(() {
      favoritesCubit.close();
    });
  });
}