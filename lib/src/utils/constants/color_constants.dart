import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primarySwatch = MaterialColor(
    0xff34495e, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff485b6e),//10%
      100: Color(0xff5d6d7e),//20%
      200: Color(0xff71808e),//30%
      300: Color(0xff85929e),//40%
      400: Color(0xff9aa4af),//50%
      500: Color(0xffaeb6bf),//60%
      600: Color(0xffc2c8cf),//70%
      700: Color(0xffd6dbdf),//80%
      800: Color(0xffebedef),//90%
      900: Color(0xffffffff),//100%
    },
  );

   static const MaterialColor primarySwatch1 = MaterialColor(
    0xff34495e, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff2f4255),//10%
      100: Color(0xff2a3a4b),//20%
      200: Color(0xff243342),//30%
      300: Color(0xff1f2c38),//40%
      400: Color(0xff1a252f),//50%
      500: Color(0xff151d26),//60%
      600: Color(0xff10161c),//70%
      700: Color(0xff0a0f13),//80%
      800: Color(0xff050709),//90%
      900: Color(0xff000000),//100%
    },
  );
}

//------------------------NEW DESIGN COLORS------------------------

const Color primaryColor = Color(0xffD62D00);
const Color transparentColor = Colors.transparent;

const Color whiteColor = Color(0xffFFFFFF);
const Color blackColor = Color(0xff000000);
const Color greyLightColor = Color(0xffC9C9C9);

const Color chooseMembershipContainerColor = Color(0xff5267BC);

// Text color
const Color primaryTextColorDark = Color(0xffFFFFFF);
const Color secondaryTextColorDark = Color(0xffC0C0C3);
const Color viewDetailsTextColorDark = Color(0xffFFD100);
const Color linkTextColorDark = Color(0xff3AB3EA);
const Color versionTextColorDark = Color(0xffFFFFFF);
const Color suspendedAccountTextColorDark = Color(0xffFFAC3F);

const Color primaryTextColorLight = Color(0xff020720);
const Color secondaryTextColorLight = Color(0xff666666);
const Color viewDetailsTextColorLight = Color(0xffD62D00);
const Color linkTextColorLight = Color(0xffFF8400);
const Color versionTextColorLight = Color(0xff999999);
const Color suspendedAccountTextColorLight = Color(0xffDB6600);

//Icon color
const Color iconColorDark = Color(0xffFFFFFF);
const Color navBarIconColorDark = Color(0xffFFFFFF);

const Color iconColorLight = Color(0xff020720);
const Color navBarIconColorLight = Color(0xff8B8B9D);

//Button color
const Color buttonColorDark = Color(0xffD62D00);
const Color cancelButtonColorDark = Color(0xffC0C0C3);
const Color tabColorDark = Color(0xffFFD100);

const Color buttonColorLight = Color(0xffD62D00);
const Color cancelButtonColorLight = Color(0xff6F6F85);
const Color tabColorLight = Color(0xffFF8400);

//Radio Button color
const Color selectedRadioButtonColorDark = Color(0xffD62D00);
const Color unSelectedRadioButtonColorDark = Color(0xffAFAFAF);

//surface color
const Color surfaceColorDark = Color(0xff020720);
Color dividerColorDark = const Color(0xffFFFFFF).withOpacity(0.20);
Color containerColorDark = const Color(0xffFFFFFF).withOpacity(0.12);

const Color surfaceColorLight = Color(0xffF3F3F5);
const Color dividerColorLight = Color(0xffC0C0C3);
const Color containerColorLight = Color(0xffDEDEE1);

const Color colorWhite = Color(0xffffffff);
const Color colorBlack = Color(0xff000000);
const Color primaryButtonColor = Color(0xff34495e);
const Color textFieldTitleColor = Color(0xffa7aec9);
const Color textFieldBackgroundColor = Color(0xfff2f2f2);
const Color navBarBackGroundColor = Color(0xff91d3a8);
const Color iconContainerBackGround = Color(0xff34495e);
const Color textContainerBackGround = Color(0xff6a888c);
