import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:cross_file/cross_file.dart';
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

Future<Uint8List> compressImageByXFileBase(XFile xfile, Options opts) {
  throw UnimplementedError(
      "compressImageByXFile doesn't work on platforms other than web");
}

Future<Uint8List> compressImageBase(
    String filename, Uint8List data, String mineType, Options opts) {
  throw UnimplementedError(
      "compressImage doesn't work on platforms other than web");
}
