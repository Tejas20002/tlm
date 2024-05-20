import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tlm/src/admin/screens/dashboard/model/pdf_file_model.dart';
import 'package:tlm/src/screens/homescreen/model/res_book_listing.dart';
import 'package:tlm/src/screens/login/login_screen.dart';
import 'package:tlm/src/screens/pdfviewscreen/pdf_part_screen.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/common_function.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/utils/http/data_utils.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences_keys.dart';
import 'package:tlm/src/widget/custom_outlined_button.dart';
import 'package:tlm/src/widget/custom_text_field.dart';

import '../pdfviewscreen/pdf_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List<PdfFileModel> _pdfs = [];
  String pass = '';
  late TabController tabController;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  final ValueNotifier<List<Book>> _bookList = ValueNotifier([]);
  final ValueNotifier<List<Book>> _searchBookList = ValueNotifier([]);

  @override
  void initState() {
    _getPdfList();
    getPassword();
    _getBookListing();
    super.initState();
  }

    void _filterSearchResults(String query) {
    List<Book> searchResults = [];
    if (query.isNotEmpty) {
      for (var element in _bookList.value) {
        if (element.name!.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(element);
        }
      }
    } else {
      searchResults.addAll(_bookList.value);
    }
    setState(() {
      _searchBookList.value.clear();
      _searchBookList.value.addAll(searchResults);
    });
  }

  Future<void> getPassword() async {
    pass = await readAndDecryptString();
    print(pass);
  }

  Future<void> _getPdfList() async {
    final files = await getPdfFiles();
    setState(() {
      _pdfs = files;
    });
  }

  _getBookListing() {
    try {
      isLoading.value = true;
      dataUtils.getBookListing(context).then((value) {
        if (value.status ?? false) {
          _bookList.value = value.book!;
          _searchBookList.value = [..._bookList.value];
          _syncFolder();
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      });
    } on Exception {
      isLoading.value = false;
    }
  }

  _syncFolder() async {
    final directory = Directory("${await getDirectoryPath()}pdf");
    final files = directory.listSync(
        recursive: false); // Adjust `recursive` for subfolders

    List<String> folders = [];
    List<String> bookList = [];

    for (var element in _bookList.value) {
      bookList.add(element.id.toString());
    }

    for (var element in files) {
      folders.add(element.path
          .split((Platform.isMacOS || Platform.isAndroid || Platform.isIOS)
              ? "/"
              : Platform.isWindows
                  ? "\\"
                  : "/")
          .last);


    }
    debugPrint("book $bookList");
    debugPrint("folder $folders");

    // Convert lists to sets to leverage set operations
    Set<String> uncommon1 = folders.toSet().difference(bookList.toSet());

    debugPrint("Uncommon ${uncommon1.toList()}");

    uncommon1.toList().forEach((element) {
      var file = File(
          "${directory.path}${(Platform.isMacOS || Platform.isAndroid || Platform.isIOS) ? "/" : Platform.isWindows ? "\\" : "/"}$element");
      file.deleteSync(recursive: true);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Form(
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      suffixIcon: const Icon(Iconsax.search_normal),
                      hintText: 'Search',
                      onChanged: _filterSearchResults,
                    ),
                  ),
                  _width(10),
                  CustomOutlinedButton(
                    buttonLabel: "Sign out",
                    onPressed: () {
                      clearAllLogoutPreferences();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    },
                  ), _width(10),
                  CustomOutlinedButton(
                    buttonLabel: "Refresh",
                    onPressed: () {
                     _getBookListing();
                    },
                  ),
                ],
              ),
            ),
          ),
          _height(10),
          _getPdfListWidget()
        ],
      ),
    );
  }

  Widget _getPdfListWidget() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: _searchBookList,
        builder: (context, value, child) => isLoading.value ? const Center(
          child: CircularProgressIndicator(color: primaryButtonColor),
        ) : value.isEmpty
            ? Center(
                child: Text(
                "No data found",
                style: styleSegoeBold(18, secondaryTextColorLight),
              ))
            : GridView.builder(
              itemCount: value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // number of items in each row
                  mainAxisSpacing: 8.0, // spacing between rows
                  crossAxisSpacing: 8.0, // spacing between columns
              childAspectRatio: 1.3,
                ),
            itemBuilder: (context, index) {
              var file = value[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfPartScreen(
                            book: file, bookTitle: file.name! ?? ""),
                      ));
                },
                child: Container(
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
                  child: Center(
                    child: Text(
                      "${file.name}",
                      // _platformFile!.name,
                      style: styleSegoeSemiBold(13, Colors.black),
                    ),
                  ),
                ),
              );
            },
                          ),
      ),
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
