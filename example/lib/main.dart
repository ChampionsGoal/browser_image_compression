import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _imageNotifier = ValueNotifier<Uint8List?>(null);
  final _progressIndicatorNotifier = ValueNotifier<double?>(null);
  String comparisonSize = "";

  onButtonPressed() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  child: const Text('pick image'),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ValueListenableBuilder<double?>(
                          valueListenable: _progressIndicatorNotifier,
                          builder: (context, value, child) {
                            if (kDebugMode) {
                              print(_progressIndicatorNotifier.value);
                            }
                            if (value != null) {
                              return CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 10.0,
                                percent: value / 100,
                                center: Text("$value%"),
                                backgroundColor: Colors.grey,
                                progressColor: Colors.blue,
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    ValueListenableBuilder<Uint8List?>(
                        valueListenable: _imageNotifier,
                        builder: (context, value, child) {
                          if (value != null) {
                            return Column(
                              children: [
                                Text(comparisonSize),
                                Image.memory(value),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
