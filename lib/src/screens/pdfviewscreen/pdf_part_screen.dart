import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tlm/src/screens/homescreen/model/res_book_listing.dart';
import 'package:tlm/src/screens/pdfviewscreen/pdf_view_screen.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/common_function.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences_keys.dart';
import 'package:tlm/src/widget/custom_text_field.dart';

class PdfPartScreen extends StatefulWidget {
  final Book book;
  final String bookTitle;

  const PdfPartScreen({super.key, required this.book, required this.bookTitle});

  @override
  State<PdfPartScreen> createState() => _PdfPartScreenState();
}

class _PdfPartScreenState extends State<PdfPartScreen> {
  List<bool> _shimmerEnable = [];
  List<bool> _fileExists = [];
  String password = "";
  String directory = "";

  @override
  void initState() {
    _shimmerEnable =
        List.generate(int.parse(widget.book.bookPart!), (index) => false);
    _fileExists =
        List.generate(int.parse(widget.book.bookPart!), (index) => false);
    preCheckData();
    super.initState();
  }

  Future<void> preCheckData() async {
    for (var i = 0; i < int.parse(widget.book.bookPart!); i++) {
      if (await ifFileExists(i)) {
        _fileExists[i] = true;
        setState(() {});
      } else {
        _fileExists[i] = false;
        setState(() {});
      }
    }
  }

  Future<bool> ifFileExists(int index) async {
    password = await readAndDecryptString();
    directory = await getDirectoryPath();
    var file = File("${directory}pdf/${widget.book.id}/${index + 1}.pdf");
    bool fileExist = await file.exists();
    return fileExist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.bookTitle,
          style: styleSegoeBold(18, Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.builder(
        itemCount:
            widget.book.bookPart != null ? int.parse(widget.book.bookPart!) : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              bool fileExist = await ifFileExists(index);
              if (!fileExist) {
                if (!_shimmerEnable[index]) {
                  final task = DownloadTask(
                      url:
                          'https://api.tlm.northstar.edu.in/api/book/${widget.book.id}/${index + 1}',
                      httpRequestMethod: 'POST',
                      urlQueryParameters: {'password': password},
                      filename: '${index + 1}.pdf',
                      headers: {'Authorization': getUserToken() ?? ''},
                      directory: "pdf/${widget.book.id}/",
                      baseDirectory: BaseDirectory.applicationSupport,
                      updates: Updates.statusAndProgress,
                      // request status and progress updates
                      requiresWiFi: false,
                      retries: 5,
                      allowPause: true,
                      metaData: 'data for me');

                  final result = await FileDownloader().download(task,
                      onProgress: (progress) {
                    _enableShimmerEffect(index: index, value: true);
                    print('Progress: ${progress * 100}%');
                  }, onStatus: (status) {
                    print('Status: $status');
                  });

                  switch (result.status) {
                    case TaskStatus.complete:
                      preCheckData();
                      _enableShimmerEffect(index: index, value: false);
                      print('Success!');
                      break;

                    case TaskStatus.canceled:
                      print('Download was canceled');
                      preCheckData();
                      _enableShimmerEffect(index: index, value: false);
                      break;

                    case TaskStatus.paused:
                      print('Download was paused');
                      break;

                    default:
                      _enableShimmerEffect(index: index, value: false);
                      preCheckData();
                      print('Download not successful');
                  }
                }
              } else {
                password = await readAndDecryptString();
                directory = await getDirectoryPath();
                var file =
                    File("${directory}pdf/${widget.book.id}/${index + 1}.pdf");
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewScreen(
                        pdfFile: File(file.path),
                        password: password,
                        title: "${widget.bookTitle} Part ${index + 1}",
                      ),
                    ));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_shimmerEnable[index])
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: primaryButtonColor.withOpacity(0.15),
                      highlightColor: textFieldBackgroundColor.withOpacity(0.2),
                      enabled: _shimmerEnable[index] ?? false,
                      child: _bookPartItem(index),
                    ),
                  )
                else
                  Expanded(child: _bookPartItem(index)),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // number of items in each row
          mainAxisSpacing: 8.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
          childAspectRatio: 1.3,
        ),
      ),
    );
  }

  void _enableShimmerEffect({required int index, required bool value}) {
    setState(() {
      _shimmerEnable[index] = value;
    });
  }

  Widget _bookPartItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 2,
            )
          ]),
      child: Stack(
        children: [
          Center(
            child: Text(
              "${widget.bookTitle} Part ${index + 1}",
              // _platformFile!.name,
              style: styleSegoeSemiBold(13, Colors.black),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              _fileExists[index] ? Icons.check : Icons.save_alt,
              color:
                  _fileExists[index] ? navBarBackGroundColor : buttonColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
