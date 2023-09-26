// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'package:universal_html/html.dart' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'browser_image_compression_platform_interface.dart';

/// A web implementation of the BrowserImageCompressionPlatform of the BrowserImageCompression plugin.
class BrowserImageCompressionWeb extends BrowserImageCompressionPlatform {
  /// Constructs a BrowserImageCompressionWeb
  BrowserImageCompressionWeb();

  static void registerWith(Registrar registrar) {
    BrowserImageCompressionPlatform.instance = BrowserImageCompressionWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
