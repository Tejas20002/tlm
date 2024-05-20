import 'package:flutter/material.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';

/// Custom pocket pediatrician outlined button
class CustomOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String buttonLabel;
  final Function onPressed;

  const CustomOutlinedButton({
    super.key,
    this.width,
    this.height,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? MediaQuery.of(context).size.height * 0.055,
      child: Theme(
        data: ThemeData(
          splashColor: primaryButtonColor,
          highlightColor: primaryButtonColor,
        ),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryButtonColor,
            side: const BorderSide(
              color: primaryButtonColor,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            onPressed();
          },
          child: Text(
            buttonLabel,
            style: styleSegoeBold(16, primaryButtonColor),
          ),
        ),
      ),
    );
  }
}
