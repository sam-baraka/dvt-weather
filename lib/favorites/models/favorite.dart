class Favorite {
  final String name;
  final double lat;
  final double lon;

  Favorite({
    required this.name,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
    };
  }

  factory Favorite.fromJson(Map<dynamic, dynamic> json) {
    return Favorite(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
