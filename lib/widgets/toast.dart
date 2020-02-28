import 'dart:math';

import 'package:oktoast/oktoast.dart';

class AppToast {
  AppToast._();

  static void show(String message) {
    showToast(message,
        duration: Duration(
            milliseconds: min<int>(max<int>(message.length * 50, 2000), 7000)));
  }
}
