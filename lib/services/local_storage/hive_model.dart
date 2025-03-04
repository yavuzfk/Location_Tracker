import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'hive_model.g.dart';

@HiveType(typeId: 0)
class LatLngAdapter extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  LatLngAdapter(this.latitude, this.longitude);

  LatLng toLatLng() => LatLng(latitude, longitude);

  static LatLngAdapter fromLatLng(LatLng latLng) {
    return LatLngAdapter(latLng.latitude, latLng.longitude);
  }
}
