import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:browser_image_compression/browser_image_compression_method_channel.dart';

void main() {
  MethodChannelBrowserImageCompression platform =
      MethodChannelBrowserImageCompression();
  const MethodChannel channel = MethodChannel('browser_image_compression');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getPlatformVersion':
          return '42';
        default:
          throw MissingPluginException();
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
