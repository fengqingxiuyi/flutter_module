import 'package:flutter/services.dart';

/// 调用原生的Toast组件
class ToastUtil {
  static const MethodChannel _methodChannel =
      const MethodChannel('channel_flutter_toast');

  static void toast(content) {
    _methodChannel.invokeMethod('showToast', {'content': content});
  }
}
