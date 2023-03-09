import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
            useWebWorker: true,
          ));

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
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: onButtonPressed,
                child: const Text('pick image'),
              ),
              ValueListenableBuilder<Uint8List?>(
                  valueListenable: _imageNotifier,
                  builder: (context, value, child) {
                    if (value != null) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(comparisonSize),
                            Image.memory(value),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
