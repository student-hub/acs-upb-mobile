/// This helps check whether we're in a test environment or not. This file is
/// imported when dart:io is not available (e.g. on web).
class Platform {
  static Map<String, String> environment = {};
}
