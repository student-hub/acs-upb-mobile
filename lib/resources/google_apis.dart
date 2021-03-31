import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleApiHelper {
  GoogleApiHelper();

  static const List<String> _scopes = [CalendarApi.CalendarScope];

  static List<String> get scopes => _scopes;

  static ClientId get credentials {
    String _clientIdString;

    if (kIsWeb) {
      _clientIdString =
          '611150208061-ljqdu5mfmjisdi1h3ics3l2sirvtpljk.apps.googleusercontent.com';
    }
    if (Platform.isAndroid) {
      _clientIdString =
          '611150208061-4ftun8ln4v9hm1mocqs1vqcftaanj8sj.apps.googleusercontent.com';
    } else if (Platform.isIOS) {
      _clientIdString =
          '611150208061-4ftun8ln4v9hm1mocqs1vqcftaanj8sj.apps.googleusercontent.com';
    }

    return ClientId(_clientIdString, '');
  }

}
