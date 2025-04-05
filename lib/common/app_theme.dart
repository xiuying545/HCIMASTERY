import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme();
  static Color primaryColor = Colors.blue.shade900;
  static Color textColor = const Color(0xFF2D3436);

  static ThemeData apptheme = ThemeData(
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 4,
      titleTextStyle: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );

  static TextStyle h1Style = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static TextStyle h2Style = GoogleFonts.poppins(
    fontSize: 22,
    color: primaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle h3Style = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  static TextStyle h4Style = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  static TextStyle h5Style = GoogleFonts.poppins(
    fontSize: 16,

    color: textColor,
  );
  static TextStyle h6Style = GoogleFonts.poppins(
    fontSize: 14,

    color: textColor,
  );

  static TextStyle snackBarText = GoogleFonts.poppins(
    fontSize: 16,
    color: Colors.white,
  );

  static List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}




// import 'package:flutter/material.dart';

// import 'light_color.dart';

// class AppTheme {
//   const AppTheme();
//   static ThemeData lightTheme = ThemeData(
//       backgroundColor: LightColor.background,
//       primaryColor: LightColor.background,
//       cardTheme: CardTheme(color: LightColor.background),
//       textTheme: TextTheme(bodyText1: TextStyle(color: LightColor.black)),
//       iconTheme: IconThemeData(color: LightColor.iconColor),
//       bottomAppBarColor: LightColor.background,
//       dividerColor: LightColor.lightGrey,
//       primaryTextTheme:
//           TextTheme(bodyText1: TextStyle(color: LightColor.titleTextColor)));

//   static TextStyle titleStyle =
//       const TextStyle(color: LightColor.titleTextColor, fontSize: 16);
//   static TextStyle subTitleStyle =
//       const TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);

//   static TextStyle h1Style =
//       const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
//   static TextStyle h2Style = const TextStyle(fontSize: 22);
//   static TextStyle h3Style = const TextStyle(fontSize: 20);
//   static TextStyle h4Style = const TextStyle(fontSize: 18);
//   static TextStyle h5Style = const TextStyle(fontSize: 16);
//   static TextStyle h6Style = const TextStyle(fontSize: 14);

//   static List<BoxShadow> shadow = <BoxShadow>[
//     BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
//   ];

//   static EdgeInsets padding =
//       const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
//   static EdgeInsets hPadding = const EdgeInsets.symmetric(
//     horizontal: 10,
//   );

//   static double fullWidth(BuildContext context) {
//     return MediaQuery.of(context).size.width;
//   }

//   static double fullHeight(BuildContext context) {
//     return MediaQuery.of(context).size.height;
//   }
// }