import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'dart:js_util';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:js/js.dart';

@JS()
@anonymous
class Options {
  external factory Options({
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

@JS("imageCompression")
external Promise imageCompression(File file, Options opts);

class BrowserImageCompression {
  static Future<Uint8List> compressImage(XFile xfile, Options opts) async {
    var completer = Completer<Uint8List>();

    var file = File(
      [await xfile.readAsBytes()],
      xfile.name,
      {'type': xfile.mimeType},
    );

    var value = await completerForPromise(imageCompression(file, opts)).future;

    var r = FileReader();

    r.readAsArrayBuffer(value);

    r.onLoadEnd.listen((data) {
      completer.complete(r.result as Uint8List);
    });

    return completer.future;
  }
}

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
