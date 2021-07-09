import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:flutter/material.dart';

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location);

    return PathFactory.from(uri);
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath configuration) {
    return configuration.routeInformation;
  }
}
