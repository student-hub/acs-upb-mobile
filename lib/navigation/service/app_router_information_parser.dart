import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:flutter/material.dart';

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {

    final Uri uri = Uri.parse(routeInformation.location);
    // print('\n++++++++++++\n'
    //     'parseRouteInformation: ${routeInformation.location}'
    //     '\nuri: $uri'
    //     '\n++++++++++++');
    return PathFactory.from(uri);
  }

  @override
  RouteInformation restoreRouteInformation(RoutePath configuration) {
    // print('\n++++++++++++\n'
    //     'restoreRouteInformation: $configuration'
    //     '\n++++++++++++');

    return configuration.routeInformation;
  }
}
