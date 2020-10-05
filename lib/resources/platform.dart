/// This helps test device environment by exporting either dart:io or dart:html
/// based on whether we're on web or mobile.
class Platform {
  static Map<String, String> environment = {};
}
