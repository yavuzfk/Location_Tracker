import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    //TODO: save location to internal storage.
    return Future.value(true);
  });
}
