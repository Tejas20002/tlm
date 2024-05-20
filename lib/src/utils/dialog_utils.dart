import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';
import 'package:tlm/src/widget/custom_elevated_button.dart';

//All common dialog open with this place.
class DialogUtils {
  static bool isOpenDialog = false;
  static bool isOpenDialogWithCallBack = false;

  static void showAlertDialogCustom(BuildContext context, String message,
      {Function? onPressedCallBack,
      bool isHappy = false,
      String buttonText = "Okay",
      bool isOnlyText = false,
      bool isCancelMembership = false,
      bool canDismissOnBack = true}) {
    if (!isOpenDialog) {
      isOpenDialog = true;

      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(builder: (ccontext, setState1) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(message,
                      style: styleSegoeSemiBold(16, primaryTextColorLight)),
                  const SizedBox(height: 8),
                  CustomElevatedButton(
                    buttonLabel: buttonText,
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {
                      isOpenDialog = false;
                      Navigator.pop(context);
                      try {
                        onPressedCallBack!();
                      } catch (e) {
                        print("error dialog == $e");
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }),
      ).whenComplete(() => isOpenDialog = false);
    }
  }

  // static Future<bool> displayToast(String message) {
  //   return Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 2,
  //       backgroundColor: primaryColor,
  //       textColor: Colors.white,
  //       fontSize: fontMedium);
  // }

  static SnackBar displaySnackBar({required String message}) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: primaryColor,
    );
  }

  static bool _isLoading = false;

  DialogUtils.internal();

  static BuildContext? _context;

  static void closeLoadingDialog() {
    if (_isLoading) {
      Navigator.of(_context!).pop();
      _isLoading = false;
    }
  }

  static void openLoadingDialog(BuildContext context) async {
    _context = context;
    _isLoading = true;
    await showDialog(
        context: _context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  primaryColor,
                ),
              ))
            ],
          );
        });
  }
}
