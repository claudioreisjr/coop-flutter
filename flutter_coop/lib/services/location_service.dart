import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getPosition() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception("Ative o GPS");
    }

    LocationPermission perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw Exception("Permissão negada");
      }
    }

    if (perm == LocationPermission.deniedForever) {
      throw Exception("Permissão permanentemente negada");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }
}
