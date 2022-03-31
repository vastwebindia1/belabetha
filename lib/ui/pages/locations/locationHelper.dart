/*

import 'package:geolocation/geolocation.dart';
import 'package:geocoder/geocoder.dart';

class LocationHelper {
  String latitude = '00.00000';
  String longitude = '00.00000';

  Future<dynamic> getCurrentLocation() {
    Geolocation.enableLocationServices().then((result) {
      Geolocation.currentLocation(accuracy: LocationAccuracy.medium)
          .listen((result) {
        if (result.isSuccessful) {
          final Map<String, String> location = {
            "latitude": result.location.latitude.toString(),
            "longitude": result.location.longitude.toString(),
          };
          return location;
        }
      });
    }).catchError((e) {
      return "";
    });
  }


  Future<dynamic> getAddrress(lat, long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    if (addresses != null) {
      return addresses;
    }
  }

}*/
