# Browser Image Compression

This is a flutter plugin package that compress images using the javascript library [browser_image_compression](https://github.com/Donaldcwl/browser-image-compression). This plugin only works on Web platform. Please see `browser-image-compression` repository for all image compression benefits.

Main benifits of this plugin compared with other packages currently available on pub.dev are:
- Compression works on a web worker cuncurrently with your flutter app.
- Image compression update progress.
- Also can resize image if prefered.
- You can limit the size of the compressed file in megabytes, (the lower you set the longer it takes to compress).

## Installation

- flutter pub add browser_image_compression
- append inside the `<head>` tag on `index.html`
```html
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/browser-image-compression@2.0.2/dist/browser-image-compression.js"></script>
<script>
```
- import the plugin
``` dart
    import 'package:browser_image_compression/browser_image_compression.dart';
```
- code as the example below

### Example

``` dart
final XFile? xfile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

if (xfile != null) {
    final initialSize = await xfile.length();

    _imageNotifier.value = await BrowserImageCompression.compressImage(
    xfile,
    Options(
        maxSizeMB: 1,
        maxWidthOrHeight: 2048,
        useWebWorker: true,
        onProgress: (progress) {
        _progressIndicatorNotifier.value = progress;
        },
    ),
    );

    _progressIndicatorNotifier.value = null;

    if (_imageNotifier.value != null) {
    final finalSize = (_imageNotifier.value!).length;

    var f = NumberFormat("####.0#", "en_US");

    comparisonSize =
        'initial size is $initialSize and final size is $finalSize. Compression of ${f.format(initialSize / finalSize)}x';
    }
}
```

## TODO
- Implement javascript "AbortSignal" to abort compression.

