import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

enum LocationAlwaysPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

class LocationPermissionsHandler {

  Future<bool> isGranted() async {
    final PermissionStatus status = await Permission.location.status;
    return _isGranted(status);
  }

  bool _isGranted(PermissionStatus status) {
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      return true;
    }
    return false;
  }

  Future<bool> get isAlwaysGranted {
    return Permission.locationAlways.isGranted;
  }

  Future<LocationPermissionStatus> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (_isGranted(status)) {
      return LocationPermissionStatus.granted;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }
    return LocationPermissionStatus.denied;
  }

  Future<LocationAlwaysPermissionStatus> requestLocationAlwaysPermission() async {
    PermissionStatus status = await Permission.locationAlways.request();
    if (status == PermissionStatus.granted) {
      return LocationAlwaysPermissionStatus.granted;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      return LocationAlwaysPermissionStatus.permanentlyDenied;
    }
    return LocationAlwaysPermissionStatus.denied;
  }
}
