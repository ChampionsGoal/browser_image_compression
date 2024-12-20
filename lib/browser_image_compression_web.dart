// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:typed_data';

import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:cross_file/cross_file.dart';
import 'package:js/js.dart';
import 'package:universal_html/html.dart' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:universal_html/html.dart';

import 'browser_image_compression_platform_interface.dart';

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

  @override
  Future<Uint8List> compressImageByXFile(XFile xfile, Options opts) async {
    var completer = Completer<Uint8List>();

    var file = File(
      [await xfile.readAsBytes()],
      xfile.name,
      {'type': xfile.mimeType},
    );

    OptionsBase optionsBase = OptionsBase.fromOptions(opts);

    var value =
        await completerForPromise(imageCompression(file, optionsBase.impl))
            .future;

    var r = FileReader();

    r.readAsArrayBuffer(value);

    r.onLoadEnd.listen((data) {
      completer.complete(r.result as Uint8List);
    });

    return completer.future;
  }

  @override
  Future<Uint8List> compressImage(
      String filename, Uint8List data, String mineType, Options opts) async {
    var completer = Completer<Uint8List>();

    var file = File(
      [data],
      filename,
      {'type': mineType},
    );

    OptionsBase optionsBase = OptionsBase.fromOptions(opts);

    var value =
        await completerForPromise(imageCompression(file, optionsBase.impl))
            .future;

    var r = FileReader();

    r.readAsArrayBuffer(value);

    r.onLoadEnd.listen((data) {
      completer.complete(r.result as Uint8List);
    });

    return completer.future;
  }
}

@JS()
@anonymous
class OptionsJS {
  external factory OptionsJS({
    /** @default Number.POSITIVE_INFINITY */
    double? maxSizeMB,
    /** @default undefined */
    double? maxWidthOrHeight,
    /** @default true */
    bool? useWebWorker,
    /** @default 10 */
    double? maxIteration,
    /** Default to be the exif orientation from the image file */
    double? exifOrientation,
    /** A function takes one progress argument (progress from 0 to 100) */
    Function(double progress)? onProgress,
    /** Default to be the original mime type from the image file */
    String? fileType,
    /** @default 1.0 */
    double? initialQuality,
    /** @default false */
    bool? alwaysKeepResolution,
    /** @default undefined */
    // AbortSignal? signal,
    /** @default false */
    bool? preserveExif,
    /** @default https://cdn.jsdelivr.net/npm/browser-image-compression/dist/browser-image-compression.js */
    String? libURL,
  });
}

class OptionsBase {
  late OptionsJS impl;

  // OptionsBase({
  //   /** @default Number.POSITIVE_INFINITY */
  //   double maxSizeMB = 1,
  //   /** @default undefined */
  //   double maxWidthOrHeight = 2048,
  //   /** @default true */
  //   bool useWebWorker = true,
  //   /** @default 10 */
  //   double maxIteration = 10,
  //   /** Default to be the exif orientation from the image file */
  //   double? exifOrientation,
  //   /** A function takes one progress argument (progress from 0 to 100) */
  //   Function(double progress)? onProgress,
  //   /** Default to be the original mime type from the image file */
  //   String? fileType,
  //   /** @default 1.0 */
  //   double initialQuality = 1,
  //   /** @default false */
  //   bool alwaysKeepResolution = false,
  //   /** @default undefined */
  //   // AbortSignal? signal,
  //   /** @default false */
  //   bool preserveExif = false,
  //   /** @default https://cdn.jsdelivr.net/npm/browser-image-compression/dist/browser-image-compression.js */
  //   String? libURL,
  // }) : impl = OptionsJS(
  //         maxSizeMB: maxSizeMB,
  //         maxWidthOrHeight: maxWidthOrHeight,
  //         useWebWorker: useWebWorker,
  //         maxIteration: maxIteration,
  //         exifOrientation: exifOrientation,
  //         onProgress: (onProgress != null) ? allowInterop(onProgress) : null,
  //         fileType: fileType,
  //         initialQuality: initialQuality,
  //         alwaysKeepResolution: alwaysKeepResolution,
  //         preserveExif: preserveExif,
  //         libURL: libURL,
  //       );

  OptionsBase.fromOptions(Options options)
      : impl = OptionsJS(
          maxSizeMB: options.maxSizeMB,
          maxWidthOrHeight: options.maxWidthOrHeight,
          useWebWorker: options.useWebWorker,
          maxIteration: options.maxIteration,
          exifOrientation: options.exifOrientation,
          onProgress: (options.onProgress != null)
              ? allowInterop(options.onProgress!)
              : null,
          fileType: options.fileType,
          initialQuality: options.initialQuality,
          alwaysKeepResolution: options.alwaysKeepResolution,
          preserveExif: options.preserveExif,
          libURL: options.libURL,
        );
}

@JS("imageCompression")
external Promise imageCompression(File file, OptionsJS optionsJS);

@JS("Promise")
class Promise {
  external Object then(Function onFulfilled, Function onRejected);
  external static Promise resolve(dynamic value);
}

/// Creates a completer for the given JS promise.
Completer<T> completerForPromise<T>(Promise promise) {
  Completer<T> out = Completer();

  // Create interopts for promise
  promise.then(allowInterop((value) {
    out.complete(value);
  }), allowInterop(([value]) {
    out.completeError(value, StackTrace.current);
  }));

  return out;
}
