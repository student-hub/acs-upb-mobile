import 'dart:async';

import 'package:acs_upb_mobile/widgets/spoiler/model/spoiler_details.dart';
import 'package:flutter/cupertino.dart';

class SpoilerData {
  // ignore: close_sinks
  StreamController<SpoilerDetails> updateEvents;

  // ignore: close_sinks
  StreamController<SpoilerDetails> readyEvents;
  SpoilerDetails details;

  GlobalKey key;

  bool isOpened;

  SpoilerData(
      {this.key,
      this.updateEvents,
      this.readyEvents,
      this.details,
      this.isOpened});
}
