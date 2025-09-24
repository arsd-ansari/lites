import 'package:permission_handler/permission_handler.dart';

class RequestPermissionManager{
  final permission = Permission.location;

  static Future<bool> checkPermissionStatus() async {
    final permission = Permission.requestInstallPackages;
    return await permission.status.isGranted;
  }

  Future<bool> shouldShowRequestRationale() async {
    final permission = Permission.location;
    return await permission.shouldShowRequestRationale;
  }

  Future<bool> checkPermanentlyDenied() async {
    final permission = Permission.camera;

    return await permission.status.isPermanentlyDenied;
  }

  void openSettings() {
    openAppSettings();
  }

  static Future<bool> requestPermission() async {
    const permission = Permission.requestInstallPackages;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        // Permission is granted
        return true;
      } else if (result.isDenied) {
        // Permission is denied
        return false;
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied
        return false;
      }
    }
    return false;
  }

  static Future<bool> checkMultiplePermissionStatus() async {
    final permission = Permission.manageExternalStorage;
    return await permission.status.isGranted;
  }

  static Future<bool> requestMultiplePermission() async {
    const permission = Permission.manageExternalStorage;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        // Permission is granted
        return true;
      } else if (result.isDenied) {
        // Permission is denied
        return false;
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied
        return false;
      }
    }
    return false;
  }

  Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
  // /// Permission type to request permission from user
  // PermissionType? _permissionType;
  //
  // /// callback when permission is denied by user
  // Function()? _onPermissionDenied;
  //
  // /// callback when permission is granted by user
  // Function()? _onPermissionGranted;
  //
  // /// callback when permission is permanently denied by user
  // Function()? _onPermissionPermanentlyDenied;
}