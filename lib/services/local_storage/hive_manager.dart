import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location_tracker/services/local_storage/hive_model.dart';

//TODO: DI

class HiveManager {
  static const String _boxName = "locationBox";

  static Future<void> init() async {
    Hive.registerAdapter(LatLngAdapterAdapter());
    await Hive.openBox<LatLngAdapter>(_boxName);
  }

  static Future<void> hiveWrite(List<LatLng> locations) async {
    final box = Hive.box<LatLngAdapter>(_boxName);
    await box.clear();
    for (var latLng in locations) {
      await box.add(LatLngAdapter.fromLatLng(latLng));
    }
  }

  static List<LatLng> hiveRead() {
    final box = Hive.box<LatLngAdapter>(_boxName);
    return box.values.map((latLngAdapter) => latLngAdapter.toLatLng()).toList();
  }

  static Future<void> hiveDeleteAll() async {
    final box = Hive.box<LatLngAdapter>(_boxName);
    await box.clear();
  }
}
