import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/constants/textstyle_constant.dart';

/// Custom pocket pediatrician textfield
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? title;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Function? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final TextAlign? textAlign;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.title,
    this.hintText,
    this.autofocus = false,
    this.enabled = true,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != null)...[
          Text(
          title ?? "",
          style: styleSegoeBold(14, textFieldTitleColor),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 5),
        ],
        Container(
          decoration: BoxDecoration(
            color: textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            inputFormatters: inputFormatters,
            onTap: () {
              if(onTap != null) {
                onTap!();
              }
            },
            onChanged: onChanged,
            autofocus: autofocus,
            enabled: enabled,
            readOnly: readOnly,
            maxLines: 1,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            cursorColor: primaryButtonColor,
            obscureText: obscureText,
            style: styleSegoeSemiBold(14, primaryButtonColor),
            textAlign: textAlign ?? TextAlign.left,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: styleSegoeSemiBold(14, textFieldTitleColor),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
