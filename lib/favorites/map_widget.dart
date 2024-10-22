import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.favorite,
  });

  final dynamic favorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(favorite.name),
      ),
      body: GoogleMap(
          mapType: MapType.normal,
          markers: {
            Marker(
                infoWindow: InfoWindow(title: favorite.name),
                markerId: MarkerId(favorite.name),
                position: LatLng(favorite.lat, favorite.lon))
          },
          initialCameraPosition: CameraPosition(
              zoom: 18, target: LatLng(favorite.lat, favorite.lon))),
    );
  }
}
