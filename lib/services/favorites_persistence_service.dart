import 'package:dvt_weather/favorites/models/favorite.dart';
import 'package:hive/hive.dart';

class FavoritesPersistenceService {
  final Box<List<Favorite>> favoriteBox = Hive.box<List<Favorite>>('favorites');

  saveFavorites(List<Favorite> favorites) {
    favoriteBox.put('favorites', favorites);
  }

  List<Favorite> getFavorites() {
    return favoriteBox.get('favorites') ?? [];
  }
}
