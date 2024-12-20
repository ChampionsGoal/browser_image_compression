import 'dart:typed_data';

import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:browser_image_compression/browser_image_compression_platform_interface.dart';
import 'package:browser_image_compression/browser_image_compression_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBrowserImageCompressionPlatform
    with MockPlatformInterfaceMixin
    implements BrowserImageCompressionPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Uint8List> compressImage(
      String filename, Uint8List data, String mineType, Options opts) {
    // TODO: implement compressImage
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> compressImageByXFile(XFile xfile, Options opts) {
    // TODO: implement compressImageByXFile
    throw UnimplementedError();
  }
}

void main() {
  final BrowserImageCompressionPlatform initialPlatform =
      BrowserImageCompressionPlatform.instance;

  test('$MethodChannelBrowserImageCompression is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelBrowserImageCompression>());
  });

  test('getPlatformVersion', () async {
    // BrowserImageCompression browserImageCompressionPlugin =
    //     BrowserImageCompression();
    MockBrowserImageCompressionPlatform fakePlatform =
        MockBrowserImageCompressionPlatform();
    BrowserImageCompressionPlatform.instance = fakePlatform;

    //expect(await browserImageCompressionPlugin.getPlatformVersion(), '42');
  });
}
