import 'package:dvt_weather/favorites/map_widget.dart';
import 'package:dvt_weather/services/favorites_persistence_service.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen(
      {super.key, FavoritesPersistenceService? favoritesPersistenceService})
      : favoritesPersistenceService =
            favoritesPersistenceService ?? FavoritesPersistenceService();

  final FavoritesPersistenceService favoritesPersistenceService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoritesPersistenceService.getFavorites().length,
        itemBuilder: (context, index) {
          final favorite = favoritesPersistenceService.getFavorites()[index];
          return ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MapWidget(favorite: favorite);
                  });
            },
            title: Text(favorite.name),
            subtitle: Text('Lat: ${favorite.lat}, Lon: ${favorite.lon}'),
          );
        },
      ),
    );
  }
}
