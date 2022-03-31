import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IpHelper{
  String conntype;
  String ipaddress;
  Position _currentPosition;

  // ignore: missing_return
  Future<String> getconnectivity() async{

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      conntype = 'mobileNetwork';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      conntype = 'wifi Network';
    }


    final prefs = await SharedPreferences.getInstance();
    prefs.setString('conntype', conntype);


  }
  // ignore: missing_return
  Future<String> getLocalIpAddress() async {

    final prefs = await SharedPreferences.getInstance();
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: true);


    try {

      NetworkInterface vpnInterface = interfaces.firstWhere((element) => element.name == "tun0");
      ipaddress = vpnInterface.addresses.first.address;
      prefs.setString('ipaddress', ipaddress);


    } on StateError {

      try {
        NetworkInterface interface = interfaces.firstWhere((element) => element.name == "wlan0");
        ipaddress = interface.addresses.first.address;
        prefs.setString('ipaddress', ipaddress);

      } catch (ex) {

        print(ex);

        try {
          NetworkInterface interface = interfaces.firstWhere((element) => !(element.name == "tun0" || element.name == "wlan0"));
          ipaddress = interface.addresses.first.address;
          prefs.setString('ipaddress', ipaddress);

        } catch (ex) {

          return null;

        }


      }
    }




  }

  Future<String> getCurrentLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        forceAndroidLocationManager: true)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng();

    }


    ).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placemarks[0];
      String late = _currentPosition.latitude.toString();
      String long = _currentPosition.longitude.toString();
      String address = place.street;
      String city = place.locality;
      String postalcode = place.postalCode;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lat2', late);
      prefs.setString('long2', long);
      prefs.setString('add2', address);
      prefs.setString('city2', city);
      prefs.setString('post2', postalcode);


    } catch (e) {

      print(e);
    }
  }
}