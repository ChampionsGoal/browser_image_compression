import 'dart:async';
import 'package:browser_image_compression/browser_image_compression_platform_interface.dart';
import 'package:flutter/foundation.dart';

import 'package:cross_file/cross_file.dart';

class Options {
  /// @default Number.POSITIVE_INFINITY
  final double maxSizeMB;

  /// @default undefined
  final double maxWidthOrHeight;

  /// @default true
  final bool useWebWorker;

  /// @default 10
  final double maxIteration;

  /// Default to be the exif orientation from the image file
  final double? exifOrientation;

  /// A function takes one progress argument (progress from 0 to 100)
  final Function(double progress)? onProgress;

  /// Default to be the original mime type from the image file
  final String? fileType;

  /// @default 1.0
  final double initialQuality;

  /// @default false
  final bool alwaysKeepResolution;

  /// @default undefined
  // AbortSignal? signal,

  /// @default false
  final bool preserveExif;

  /// @default https://cdn.jsdelivr.net/npm/browser-image-compression/dist/browser-image-compression.js
  final String? libURL;

  Options({
    this.maxSizeMB = 1,
    this.maxWidthOrHeight = 2048,
    this.useWebWorker = true,
    this.maxIteration = 10,
    this.exifOrientation,
    this.onProgress,
    this.fileType,
    this.initialQuality = 1,
    this.alwaysKeepResolution = false,
    this.preserveExif = false,
    this.libURL,
  });
}

class BrowserImageCompression {
  static BrowserImageCompressionPlatform get platform =>
      BrowserImageCompressionPlatform.instance;

  static set platform(BrowserImageCompressionPlatform platform) {
    BrowserImageCompressionPlatform.instance = platform;
  }

  static Future<Uint8List> compressImageByXFile(
      XFile xfile, Options opts) async {
    return platform.compressImageByXFile(xfile, opts);
  }

  static Future<Uint8List> compressImage(
      String filename, Uint8List data, String mineType, Options opts) async {
    return platform.compressImage(filename, data, mineType, opts);
  }
}
