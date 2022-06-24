import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink() async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://acsupbmobile.page.link',
      link: Uri.parse(
          'https://acsupbmobile.page.link/neews?guid=QAyniPN7bmyGzb8kOBxV'),
      androidParameters: const AndroidParameters(
        packageName: 'ro.pub.acs.acs_upb_mobile_dev',
        minimumVersion: 0,
      ),
    );

    final url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    return url.toString();
  }

  static Future<void> initDynamicLink() async {
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
    //   final Uri deepLink = dynamicLink.link;
    //   print(deepLink);
    //   String newsGuid = deepLink.queryParameters['guid'];
    // });
    // ignore: unnecessary_lambdas
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      //Navigator.pushNamed(context, dynamicLinkData.link.path);
      print('New dynamic link');
      print(dynamicLinkData);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }
}
