import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'browser_image_compression_platform_interface.dart';

/// An implementation of [BrowserImageCompressionPlatform] that uses method channels.
class MethodChannelBrowserImageCompression
    extends BrowserImageCompressionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('browser_image_compression');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
