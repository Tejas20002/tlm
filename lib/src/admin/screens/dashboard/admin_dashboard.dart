import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tlm/src/admin/provider/loader_provider.dart';
import 'package:tlm/src/admin/screens/dashboard/model/pdf_file_model.dart';
import 'package:tlm/src/screens/login/login_screen.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/common_function.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/widget/custom_elevated_button.dart';
import 'package:tlm/src/widget/custom_outlined_button.dart';
import 'package:tlm/src/widget/custom_text_field.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _employeeCodeController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  List<PdfFileModel> _pdfs = [];
  late LoaderProvider loaderProvider;

  @override
  void initState() {
    _getPdfList();
    super.initState();
  }

  Future<void> _getPdfList() async {
    final files = await getPdfFiles();
    setState(() {
      _pdfs = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    loaderProvider = context.watch<LoaderProvider>();
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    buttonLabel: "Import Pdf",
                    onPressed: () async {
                      _importPdf();
                    },
                  ),
                ),
                _width(16),
                Expanded(
                  child: CustomElevatedButton(
                    buttonLabel: "Delete All",
                    onPressed: () async {
                      if (_pdfs.isNotEmpty) {
                        setState(() async {
                          for (var element in _pdfs) {
                            await element.pdfFiles.delete();
                          }
                          showSnackBar(
                              context: context, message: "All files deleted.");
                          _getPdfList();
                        });
                      }
                    },
                  ),
                ),
                _width(16),
                Expanded(
                  child: CustomOutlinedButton(
                    buttonLabel: "Sign out",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: CustomTextField(
              controller: _searchController,
              focusNode: _searchFocus,
              suffixIcon: const Icon(Iconsax.search_normal),
              hintText: 'Search',
            ),
          ),
          _height(10),
          if (loaderProvider.isLoading)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryButtonColor,
                    value: loaderProvider.totalPages == 0
                        ? 0
                        : loaderProvider.currentPages /
                            loaderProvider.totalPages,
                  ),
                  _height(10),
                  Text(
                    "Adding watermark in ${loaderProvider.currentPdf}.\nEncrypting file ${loaderProvider.currentPdf} of ${loaderProvider.totalPdf}.",
                    style: styleSegoeSemiBold(14, textFieldTitleColor),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          else
            Expanded(
              child: _pdfs.isEmpty
                  ? Center(
                      child: Text(
                      "No data found",
                      style: styleSegoeBold(18, secondaryTextColorLight),
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _pdfs.map((file) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${file.pdfFiles.path.split((Platform.isMacOS || Platform.isAndroid || Platform.isIOS) ? '/' : '\\').last}",
                                        // _platformFile!.name,
                                        style: styleSegoeSemiBold(
                                            13, Colors.black),
                                      ),
                                      _height(5),
                                      Text(
                                        '${file.size}',
                                        // '${(_platformFile!.size / 1024).ceil()} KB',
                                        style: styleSegoeRegular(
                                            13, Colors.grey.shade500),
                                      ),
                                      _height(8),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    file.pdfFiles.delete();
                                    showSnackBar(
                                        context: context,
                                        message: "File deleted successfully");
                                    _getPdfList();
                                  },
                                  icon: const Icon(
                                    Iconsax.trash,
                                    color: buttonColorLight,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  _importPdf() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (ccontext, setState1) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomTextField(
                  controller: _employeeCodeController,
                  focusNode: _passwordFocus,
                  title: "Enter Employee Code",
                  hintText: "Employee Code",
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                ),
                _height(8),
                CustomElevatedButton(
                  buttonLabel: "Continue",
                  onPressed: () async {
                    if (_employeeCodeController.text.trim().isNotEmpty) {
                      Navigator.pop(context);
                      var files = await pickFile();
                      if (files != null) {
                        // for (final file in files) {
                        await copyFile(
                            files,
                            _employeeCodeController.text.trim(),
                            context,
                            loaderProvider);
                        _employeeCodeController.clear();
                        // }
                        Future.delayed(const Duration(seconds: 2));
                        _getPdfList();
                      } else {
                        setState(() {
                          _getPdfList();
                        });
                      }
                    } else {
                      showSnackBar(
                          context: context,
                          message: "Please enter employee code");
                    }
                  },
                  width: MediaQuery.of(context).size.width,
                ),
                _height(8),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _width(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget _height(double height) {
    return SizedBox(
      height: height,
    );
  }
}
