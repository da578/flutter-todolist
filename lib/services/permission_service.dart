import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestExactAlarmsPemission() async {
    PermissionStatus status = await Permission.scheduleExactAlarm.status;

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    if (status.isDenied) {
      status = await Permission.scheduleExactAlarm.request();
      return status.isGranted;
    }

    return status.isGranted;
  }
}
