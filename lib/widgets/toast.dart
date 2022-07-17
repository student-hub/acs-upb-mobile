import 'dart:math';
import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';

class AppToast {
  AppToast._();

  static void show(final String message) {
    showToast(message,
        textStyle: const TextStyle(
            color: Colors.white, fontFamily: 'Montserrat', fontSize: 16),
        duration: Duration(
            milliseconds: min<int>(max<int>(message.length * 50, 2000), 7000)));
  }
}
