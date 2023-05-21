import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<String> base64ImageToImageFile(String encodedData, [String extensionName = 'png']) async {
    // final encodedStr = "put base64 encoded string here";
    Uint8List bytes = base64.decode(encodedData);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.$extensionName");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
