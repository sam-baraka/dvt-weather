

import 'dart:convert';

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
    List<PlaceElement> places;

    Place({
        required this.places,
    });

    factory Place.fromJson(Map<String, dynamic> json) => Place(
        places: List<PlaceElement>.from(json["places"].map((x) => PlaceElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "places": List<dynamic>.from(places.map((x) => x.toJson())),
    };
}

class PlaceElement {
    String name;
    List<AddressComponent> addressComponents;
    Location location;

    PlaceElement({
        required this.name,
        required this.addressComponents,
        required this.location,
    });

    factory PlaceElement.fromJson(Map<String, dynamic> json) => PlaceElement(
        name: json["name"],
        addressComponents: List<AddressComponent>.from(json["addressComponents"].map((x) => AddressComponent.fromJson(x))),
        location: Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "addressComponents": List<dynamic>.from(addressComponents.map((x) => x.toJson())),
        "location": location.toJson(),
    };
}

class AddressComponent {
    String shortText;

    AddressComponent({
        required this.shortText,
    });

    factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
        shortText: json["shortText"],
    );

    Map<String, dynamic> toJson() => {
        "shortText": shortText,
    };
}

class Location {
    double latitude;
    double longitude;

    Location({
        required this.latitude,
        required this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}
