import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/responses/GetLocationModel.dart';
import 'constants.dart';

class GPSLocatorService {

  final Geolocator _geolocator = Geolocator();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<Position?> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: false,
    );
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            distanceFilter: 10, accuracy: LocationAccuracy.high)

    );
  }


  Future<LatLong> getLatLong() async {
    double long = 0.0;
    double lat = 0.0;
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          debugPrint( 'Location permissions are denied. Opening App Settings...');
          await openAppSettings();

// Wait for user action
          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            debugPrint( "User denied permission from app settings. Closing the app.");
            exit(0); // Close the app
          }
          else if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
            print('Permission granted...');
          }
        }
      }

      if (permission == LocationPermission.denied) {
        debugPrint("Location permissions are permanently denied. Opening App Settings...");
        await openAppSettings();

// Wait for user to return from settings
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          debugPrint("User permanently denied permission from app settings. Closing the app.");
          exit(0); // Close the app only if the user still denies it
        }
        else if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
          print('Permission granted...');
        }

      }

      if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
        print('Permission granted...');
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        debugPrint("GPS Location service is granted");
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 90),
        );
        long = position.longitude;
        lat = position.latitude;
        Constants.latitude = lat;
        Constants.longitude = long;
      }

      return LatLong(lat, long);
    } catch (ex) {
      debugPrint("Error fetching location: $ex");
      return LatLong(lat, long);
    }
  }


  void openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }
    debugPrint(displayValue);
  }

}

