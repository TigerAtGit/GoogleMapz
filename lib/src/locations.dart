import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.lat,
    required this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Region {
  Region({
    required this.coords,
    required this.id,
    required this.name,
    required this.zoom,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class Office {
  Office({
    required this.address,
    required this.id,
    required this.image,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.region,
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);

  final String address;
  final String id;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final String phone;
  final String region;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.offices,
    required this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Office> offices;
  final List<Region> regions;
}

Future<Locations> getGoogleOffices() async {
  // Retrieve the locations of Google offices
  Map<String, String> requestHeaders = {
    // 'Content-type': 'application/json',
    // 'Accept': 'application/json',
    'X-RapidAPI-Host': 'trueway-places.p.rapidapi.com',
    'X-RapidAPI-Key': '68ff2876d4msh5f796efcc75f6f5p1549efjsndf9ed55c25e2'
  };

  const String location = "37.783366,-122.402325";
  const String type = "cafe";
  const String radius = "100";
  const String language = "en";

  const googleLocationsURL =
      'https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=$location&type=$type&radius=$radius&language=$language';

  try {
    final response =
        await http.get(Uri.parse(googleLocationsURL), headers: requestHeaders);
    if (response.statusCode == 200) {
      print("Sahi hai bhai");
      print(json.decode(response.body));
      return Locations.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print(e);
  }

  // Fallback for when the above HTTP request fails.
  print("Lag gaye");
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/locations.json'),
    ),
  );
}
