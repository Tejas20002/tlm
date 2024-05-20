import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/widget/custom_text_field.dart';

class PdfViewScreen extends StatefulWidget {
  final File pdfFile;
  final String password;
  final String title;

  const PdfViewScreen(
      {super.key,
      required this.pdfFile,
      required this.password,
      required this.title});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late PdfDocument _document;
  final List<int> _pageNumbers = [];

  final TextEditingController _jumpToController = TextEditingController();
  final FocusNode _jumpToFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadPdfDocument();
  }

  Future<void> _loadPdfDocument() async {
    // Load PDF document
    _document = PdfDocument(
      password: widget.password,
      inputBytes: widget.pdfFile.readAsBytesSync(),
    );

    for (int i = 0; i < _document.pages.count; i++) {
      _pageNumbers.add(i + 1);
    }

    _jumpToController.text = _pageNumbers.first.toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: styleSegoeBold(18, Colors.black),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: CustomTextField(
                        controller: _jumpToController,
                        focusNode: _jumpToFocus,
                        hintText: _jumpToController.text,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          // FilteringTextInputFormatter.allow(RegExp('^([0-${_pageNumbers.last.toString()}])+\$')),
                        ],
                        onChanged: (val) async {
                          if (_jumpToController.text.trim().isNotEmpty) {
                            _pdfViewerController.jumpToPage(
                                int.parse(_jumpToController.text.trim()));
                            if (int.parse(_jumpToController.text.trim()) >
                                _pageNumbers.last) {
                              _pdfViewerController
                                  .jumpToPage(_pageNumbers.last);
                            }
                          }
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          _jumpToFocus.requestFocus();
                        },
                      ),
                    ),
                    Text(
                      " of ${_pageNumbers.last}",
                      style: styleSegoeBold(14, Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SfPdfViewer.file(
        widget.pdfFile,
        controller: _pdfViewerController,
        key: _pdfViewerKey,
        enableTextSelection: false,
        interactionMode: PdfInteractionMode.pan,
        scrollDirection: PdfScrollDirection.vertical,
        canShowPasswordDialog: false,
        password: widget.password,
        pageLayoutMode: PdfPageLayoutMode.single,
        onPageChanged: (val) {
          _jumpToController.text = _pdfViewerController.pageNumber.toString();
        },
      ),
    );
  }
}
