import 'package:flutter/material.dart';

class ThemeService {

  /// #colors
  static const Color colorOne = Color.fromRGBO(131, 58, 180, 1);
  static const Color colorTwo = Color.fromRGBO(193, 53, 132, 1);

  /// #fonts
  static const String fontHeader = "Billabong";

  /// #font_size
  static const double fontHeaderSize = 30;

  /// #style
  static const TextStyle appBarStyle = TextStyle(color: Colors.black,fontSize: fontHeaderSize,fontFamily: fontHeader);

  /// #gradient
  static BoxDecoration backgraundGradient = const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromRGBO(131, 58, 180, 1),
          Color.fromRGBO(193, 53, 132, 1),
        ]),
  );
}