import 'package:dvt_weather/favorites/models/favorite.dart';
import 'package:hive/hive.dart';

class FavoritesPersistenceService {
  final Box favoriteBox = Hive.box('favorites');

  addFavorite(favorite) {
    final favorites = getFavorites();
    favorites.add(favorite);
    saveFavorites(favorites);
  }

  saveFavorites(favorites) {
    favoriteBox.put('favorites', favorites.map((e) => e.toJson()).toList());
  }

  getFavorites() {
    final favorites = favoriteBox.get('favorites') ?? [];

    return favorites.map((e) {
      return Favorite.fromJson(e);
    }).toList();
  }
}
