// import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tlm/src/admin/provider/loader_provider.dart';
import 'package:tlm/src/admin/screens/dashboard/model/pdf_file_model.dart';

final key = enc.Key.fromUtf8('y95dy323I0XB21dwmLj2HuWi9hnOIJHt');
final iv = enc.IV.fromLength(16); // Initialization Vector

Future<String> getDirectoryPath() async {
  if (Platform.isMacOS || Platform.isAndroid || Platform.isIOS) {
    final directory = await getApplicationSupportDirectory();
    return "${directory.path}/";
  } else if (Platform.isWindows) {
    final directory = await getApplicationSupportDirectory();
    return "${directory.path}\\";
  }
  return "";
}

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_-!@^*(){}[]';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

Future<String> saveEncryptedString(String message) async {
  final encrypted = encrypt(message);
  final directoryPath = await getDirectoryPath();
  final file = File('${directoryPath}encrypted_message.txt');

  // Save encrypted data and IV separately
  await file.writeAsString('$encrypted\n${iv.base64}');
  return file.path;
}

Future<String> readAndDecryptString() async {
  final directoryPath = await getDirectoryPath();
  final file = File('${directoryPath}encrypted_message.txt');
  bool fileExist = await file.exists();
  String encryptedMessage;
  String ivBase64;
  String decrypted = '';
  if (fileExist) {
    final content = await file.readAsString();

    // Split the data at the newline
    try {
      final parts = content.split('\n');
      encryptedMessage = parts[0];
      ivBase64 = parts[1];

      // Convert IV back from base64
      final iv = enc.IV.fromBase64(ivBase64);

      decrypted = decrypt(encryptedMessage, iv);
    } catch (e) {
      await saveEncryptedString(generateRandomString(50));
      final files = await getPdfFiles();
      for (var file in files) {
        await file.pdfFiles.delete();
      }
      decrypted = await readAndDecryptString();
    }
  } else {
    await saveEncryptedString(generateRandomString(50));
    final files = await getPdfFiles();
    for (var file in files) {
      await file.pdfFiles.delete();
    }
    decrypted = await readAndDecryptString();
  }
  return decrypted;
}

String encrypt(String message) {
  final encrypter = enc.Encrypter(enc.AES(key));
  final encrypted = encrypter.encrypt(message, iv: iv);
  return encrypted.base64; // Convert to base64 for easier storage
}

String decrypt(String encryptedMessage, enc.IV iv) {
  final encrypter = enc.Encrypter(enc.AES(key));
  final decrypted =
      encrypter.decrypt(enc.Encrypted.fromBase64(encryptedMessage), iv: iv);
  return decrypted.toString();
}

Future<List<PdfFileModel>> getPdfFiles() async {
  List<PdfFileModel> pdfs = [];
  final directory = Directory("${await getDirectoryPath()}pdf");
  final files =
      directory.listSync(recursive: false); // Adjust `recursive` for subfolders
  final pdfFiles = files.where((file) => file.path.endsWith('.pdf')).toList();
  for (var element in files) {
    final file = File(element.path);
    var stats = await file.stat();
    pdfs.add(
        PdfFileModel(pdfFiles: element, size: convertFileSize(stats.size)));
  }
  return pdfs;
}

String convertFileSize(int fileSizeInBytes) {
  final suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  int index = 0;

  while (fileSizeInBytes >= 1024 && index < suffixes.length - 1) {
    fileSizeInBytes ~/= 1024;
    index++;
  }

  return "${fileSizeInBytes.toStringAsFixed(2)} ${suffixes[index]}";
}

Future<void> copyFile(List<dynamic> files,String waterMark,BuildContext context,LoaderProvider loaderProvider) async {
  loaderProvider.setLoading(true);
  loaderProvider.setTotalPdf(files.length);
  for(int i=0; i<files.length; i++) {
    loaderProvider.setCurrentPdf(i+1);
    final sourceFile = File(files[i]);

    PdfDocument document = PdfDocument(
        inputBytes: sourceFile.readAsBytesSync());
    PdfSecurity security = document.security;

    int totalPageNumber = document.pages.count;
    loaderProvider.setTotalPages(totalPageNumber);
    debugPrint("totalPageNumber ${loaderProvider.totalPages}");

    PdfPage pages = PdfPage();
    loaderProvider.setCurrentPages(0);
    debugPrint("currentPageNumber ${loaderProvider.currentPages}");
    for (int pageIndex = 0; pageIndex < totalPageNumber; pageIndex++) {
      loaderProvider.setCurrentPages(pageIndex+1);
      debugPrint("currentPageNumber ${loaderProvider.currentPages}");

      PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 120);
      Size size = font.measureString(waterMark);
      pages = document.pages[pageIndex];

      Size pageSize = pages.getClientSize();
      PdfGraphics graphics = pages.graphics;

      double x = pageSize.width / 2;
      double y = pageSize.height / 2;
      graphics.save();
      graphics.restore();
      graphics.translateTransform(x, y);
      graphics.setTransparency(0.25);
      graphics.rotateTransform(-40);

      graphics.drawString(waterMark, font,
          pen: PdfPen(PdfColor(255, 0, 0)),
          brush: PdfBrushes.red,
          bounds: Rect.fromLTWH(
              -size.width / 2, -size.height / 2, size.width, size.height));

      graphics.restore();
      await Future.delayed(const Duration(microseconds: 50));
    }

    security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
    security.userPassword = await readAndDecryptString();

    final destinationPath =
        "${await getDirectoryPath()}pdf${(Platform.isMacOS ||
        Platform.isAndroid || Platform.isIOS) ? '/' : '\\'}${sourceFile.path
        .split(Platform.isMacOS ? '/' : '\\')
        .last}";
    final destinationFile = File(destinationPath);

    // Check if source file exists
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist.');
    }

    // Create the destination directory if it doesn't exist
    final parentDir = destinationFile.parent;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    // Copy the file
    // await sourceFile.copy(destinationPath);
    destinationFile.writeAsBytes(await document.save());
    document.dispose();
    print('File copied successfully!');
  }
  loaderProvider.setLoading(false);
}

Future<List> pickFile() async {
  // List<Map<String, String>> _pdfFilter = [
  //   {'description': 'PDF Files', 'extensions': 'pdf'}
  // ];

  final result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['pdf', 'PDF'],
  );
  var filePaths = [];

  if (result != null) {
    filePaths = result.files.map((file) => file.path).toList();
  }
  return filePaths;
}

showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
