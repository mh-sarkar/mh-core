import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

  static Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  static String? localImageToBase64(String imagePath) {
    if (imagePath.isEmpty) {
      return null;
    }
    List<int> imageBytes = File(imagePath).readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
