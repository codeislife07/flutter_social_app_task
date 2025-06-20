import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_app_task/common/theme/colors.dart';

// import 'fade_through_transition.dart';
// import 'fonts.dart';

IconThemeData customIconTheme(IconThemeData original) {
  return original.copyWith(color: kGrey900);
}

ThemeData buildLightTheme(
  String? language, [
  String fontFamily = 'Roboto',
  String fontHeader = 'Raleway',
]) {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    primaryColor: AppColorsBoostrap.primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsBoostrap.primary,
        // surfaceTintColor: AppColorsBoostrap.primary1,
        foregroundColor: AppColorsBoostrap.light,
        minimumSize: const Size(120, 40),
        padding: EdgeInsets.symmetric(vertical: 15),
        elevation: 0,
        iconColor: AppColorsBoostrap.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 40),
        padding: EdgeInsets.symmetric(vertical: 15),
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    // pageTransitionsTheme: const PageTransitionsTheme(
    //   builders: {
    //     TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
    //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    //   },
    // ),
  );

  return base.copyWith(
    brightness: Brightness.light,
    cardColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      colorScheme: kColorScheme,
      textTheme: ButtonTextTheme.normal,
      buttonColor: kDarkBG,
    ),
    primaryColorLight: kLightBG,
    primaryIconTheme: customIconTheme(base.iconTheme),

    iconTheme: customIconTheme(base.iconTheme),
    hintColor: Colors.black26,
    primaryColor: kLightPrimary,
    scaffoldBackgroundColor: kLightBG,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      labelStyle: TextStyle(color: AppColorsBoostrap.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColorsBoostrap.secondary.withOpacity(0.1),
          width: 1,
        ), // Set your desired color and width here
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColorsBoostrap.secondary.withOpacity(0.1),
          width: 1,
        ), // Set your desired color and width here for focused border
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColorsBoostrap.secondary.withOpacity(0.1),
          width: 1,
        ), // Set your desired color and width here for focused border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: AppColorsBoostrap.secondary.withOpacity(0.1),
          width: 1,
        ), // Set your desired color and width here for focused border
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: kDarkBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: kDarkBG),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder:
          (BuildContext context) => CircleAvatar(
            backgroundColor: Colors.white,
            child: const Icon(
              CupertinoIcons.back,
              // color: kLightBG,
            ),
          ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      dividerColor: Colors.transparent,
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: 13),
      unselectedLabelStyle: TextStyle(fontSize: 13),
    ),
    dialogBackgroundColor: kLightBG,
    colorScheme: kColorScheme
        .copyWith(secondary: kLightAccent)
        .copyWith(background: Colors.white)
        .copyWith(error: kErrorRed),
  );
}
