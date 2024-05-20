import 'package:flutter/material.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';


/// Custom pocket pediatrician elevated button
class CustomElevatedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String buttonLabel;
  final Function onPressed;

  const CustomElevatedButton({
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
          splashColor: colorWhite,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            onPressed();
          },
          child: Text(
            buttonLabel,
            style: styleSegoeBold(16, whiteColor),
          ),
        ),
      ),
    );
  }
}
