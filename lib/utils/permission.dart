import 'package:flutter_module/utils/toast.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  final status = await Permission.location.request();

  if (status == PermissionStatus.granted) {
    return true;
  } else {
    ToastUtil.toast("需要定位权限!");
    return false;
  }
}
