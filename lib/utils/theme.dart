import 'package:flutter/material.dart';

class ThemeColors {
  static Color defaultPaltetteColor = const Color(0xffff7656);
  static Color paltetteColor1 = const Color(0xffff5a5a);
  static Color paltetteColor2 = const Color(0xffff9252);

  static int backgroundColorHex = 0xFFFFFFFF; //0xFF2D2D2D
  static Color backgroundColor = const Color(
      0xFFFFFFFF); //const Color(0xFF2D2D2D);

  static Color primaryColor = const Color(0xFF2D2D2D);
  static Color success = const Color(0xFF2FDF75);
  static Color warning = const Color(0xFFFFC061);
  static Color alert = const Color(0xFFED576B);
  static Color info = const Color(0xFF79B7FF);
  static Color logo = const Color(0xFF8CE3FF);

  static Color card = const Color(0xFFE8503C);
  static Color cardBorder = const Color(0xFF000000);

  static Color? backgroundCardColor = Colors.grey[100];

  static Color secondaryColor = const Color(0xFFE8503C);
  static Color textPrimary = const Color(0x8A000000);
  static Color textSecondary = const Color(0xFF616161);
  static Color dividerColor = const Color(0x8A000000);
  static Color snackBarBackgroundColor = const Color(0xFFF44336);
  static Color snackBarTextColor = const Color(0xFFFFFFFF);
  static Color searchBarColor = const Color(0xFF9E9E9E);

  static Map<int, Color> backgroundColorMaterial = {
    50: const Color(0xFF2D2D2D).withOpacity(.1),
    100: const Color(0xFF2D2D2D).withOpacity(.2),
    200: const Color(0xFF2D2D2D).withOpacity(.3),
    300: const Color(0xFF2D2D2D).withOpacity(.4),
    400: const Color(0xFF2D2D2D).withOpacity(.5),
    500: const Color(0xFF2D2D2D).withOpacity(.6),
    600: const Color(0xFF2D2D2D).withOpacity(.7),
    700: const Color(0xFF2D2D2D).withOpacity(.8),
    800: const Color(0xFF2D2D2D).withOpacity(.9),
    900: const Color(0xFF2D2D2D).withOpacity(1),
  };
}
