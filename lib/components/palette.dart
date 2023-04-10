import 'dart:math';
import 'package:flutter/material.dart';

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);

class Palette {
  Palette._();

  // Primary color
  static MaterialColor ustBlue = generateMaterialColor(const Color(0xFF003366));
  static MaterialColor ustGold = generateMaterialColor(const Color(0xFF996600));
  static MaterialColor ustYellow = generateMaterialColor(const Color(0xFFCC9900));
  static MaterialColor ustGrey = generateMaterialColor(const Color(0xFFCCCCCC));

  // Secondary color / Accent colors
  static Color darkNavy = const Color(0xFF003E4E);
  static Color darkSteelBlue = const Color(0xFF2B6297);
  static Color oceanBlue = const Color(0xFF0074BC);
  static Color skyBlue = const Color(0xFF63CAE1);

  static Color yolkYellow = const Color(0xFFFFD400);
  static Color lightGreen = const Color(0xFFA3CF62);
  static Color lightSeaGreen = const Color(0xFF00B08D);
  static Color crayolaGreen = const Color(0xFF009A61);

  static Color firebirdRed = const Color(0xFFED1B2F);
  static Color darkRed = const Color(0xFF7C2348);
  static Color orange = const Color(0xFFFAA61A);
  static Color coolGrey = const Color(0xFF8C8F90);

}