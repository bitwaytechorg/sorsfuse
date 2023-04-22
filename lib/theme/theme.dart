import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;

ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: CONFIG.primaryColor,
    secondaryHeaderColor: Color(0xFF7a97d1),
    accentColor: Color(0xFF1990D0),
    brightness: Brightness.dark,
    canvasColor: Color(0xFF000000),
    backgroundColor: Colors.transparent,
    primaryColorLight: Color(0xFFe3defe),
    primaryColorDark: Color(0xFF1990D0),
    textTheme: TextTheme(
      headline6: TextStyle(
          color: Color(0xFF1990D0), fontSize: 18),
      subtitle2: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Color(0xFF1990D0),
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(color: Colors.white),
      bodyText1: TextStyle(color: Colors.grey),
      headline4: TextStyle(color: Color(0xFF1990D0)),
      headline3: TextStyle(color: Color(0xFFFFFFFF)),
      headline2: TextStyle(color: Color(0xFF1990D0)),
      caption: TextStyle(color: Colors.grey, fontSize: 14),
    ),
    buttonTheme: ButtonThemeData(buttonColor: CONFIG.primaryColor,shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(18.0),)),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(foregroundColor: MaterialStateProperty.all(CONFIG.primaryColor))),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xCCEFF3F7),
      filled:true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Colors.transparent,
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Colors.transparent,
          )
      ),
      helperStyle:
      TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      hintStyle: TextStyle(color:Colors.black87, fontWeight: FontWeight.w300),
      labelStyle: TextStyle(color: Colors.white70),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        modalBackgroundColor: Color(0xFF333333)),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.transparent, type: BottomNavigationBarType.fixed, elevation:2.0),
    colorScheme: ColorScheme(
      background: Color(0xFF232323),
      primary: Color(0xFF1990D0),
      //primary: Color(0xFF000000),
      //primaryVariant: Color(0xFF518bc6),
      primaryVariant: Color(0xFF1990D0),
      secondary: Color(0xFF1990D0),
      secondaryVariant: Color(0xFF1990D0),
      error: Colors.red,
      surface: Color(0xFF333333),
      brightness: Brightness.dark,
      onBackground: Color(0xFFFFFFFF),
      onError: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFFEDEDED),
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0XFFFF0087),
        textTheme: TextTheme(
            subtitle1: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white54, size: 18.0),
        actionsIconTheme: IconThemeData(color: Colors.white54, size: 8.0)));

ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: CONFIG.primaryColor,
    accentColor: CONFIG.secondaryColor,
    canvasColor: Color(0xFFFFFFFF),
    primaryColorLight: CONFIG.secondaryColor,
    primaryColorDark: CONFIG.primaryColor,
    splashColor: Colors.transparent,
    textTheme: TextTheme(
      titleSmall: TextStyle(
          color: Color(0xFF383B45),
          fontFamily:"Futura",
          fontWeight: FontWeight.normal),
      titleMedium: TextStyle(
          color: Color(0xFF383B45),
          fontFamily:"Futura",
          fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black87,fontFamily:"Futura",),
      bodyLarge: TextStyle(color: Colors.grey,fontFamily:"Futura",),
      bodySmall: TextStyle(color: Colors.black54,fontFamily:"Futura",),
      titleLarge: TextStyle(color: Color(0xFF383B45),fontSize: 18,fontFamily:"Futura",),
      headlineSmall: TextStyle(color: Color(0xFF383B45),fontFamily:"Futura",),
      headlineMedium: TextStyle(color: Color(0xFF383B45),fontFamily:"Futura",),
      displaySmall: TextStyle(color: Color(0xFF383B45),fontFamily:"Futura",),
      displayMedium: TextStyle(color: Color(0xFF383B45),fontFamily:"Futura",),
      displayLarge: TextStyle(color: Color(0xFF383B45),fontFamily:"Futura",),
      labelMedium: TextStyle(color: Color(0xFF383B45), fontSize: 18,fontFamily:"Futura",),
    ),
    buttonTheme: ButtonThemeData(buttonColor: Colors.transparent, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0),)),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(padding: EdgeInsets.all(13),textStyle: TextStyle(color: Colors.white, fontSize: 16), backgroundColor: CONFIG.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(shadowColor: Colors.transparent, surfaceTintColor: Colors.transparent,padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),textStyle: TextStyle(color: Colors.white, fontSize: 16), backgroundColor: CONFIG.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
    inputDecorationTheme: InputDecorationTheme(
     // fillColor: Color(0xFFEFF3F7),
      fillColor: Colors.white,
      filled:true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            //color: Color(0xFFe4e8ed),
              color:Colors.grey[300]!
          )
      ),
      enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            //color: Color(0xFFe4e8ed),
              color:Colors.grey[300]!
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(
            // color: Color(0xFFe4e8ed),
              color:Colors.grey[300]!
          )
      ),
      helperStyle:
      TextStyle(color: Colors.black87, fontWeight: FontWeight.w300),
      hintStyle: TextStyle(color: Colors.black54, fontWeight: FontWeight.w300),
      labelStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    ),
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: Color(0xFFFFFFFF)),
    //bottomAppBarTheme: BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
    //bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.transparent, type: BottomNavigationBarType.shifting, elevation:0.0),
    colorScheme: ColorScheme(
      background: Color(0xFFFFFFFF),
      primary: CONFIG.primaryColor,
      primaryVariant: Color(0xFF71B5D9),
      secondary: CONFIG.secondaryColor,
      secondaryVariant: CONFIG.secondaryColor,
      error: Colors.red,
      surface: Color(0xFFFFFFFF),
      brightness: Brightness.light,
      onBackground: Colors.black54,
      onError: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Colors.black87,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        brightness: Brightness.light),
    sliderTheme: const SliderThemeData(
        trackHeight: 1,
        activeTrackColor: Color(0xFFffa9d6),
        thumbColor: Color(0xFFffa9d6),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
        rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 7)
    )
);
