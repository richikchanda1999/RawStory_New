import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin PostPageStyle {
  TextStyle get headlineStyle => TextStyle(
    color: Colors.black, 
    fontSize: 50.ssp,fontFamily: 'Oswald');
  Map<String, Style> get descriptionStyle => {
    "html": Style(
 
      color: Colors.black,
      fontFamily: 'PTSerif',
      fontSize: FontSize(30.ssp),
    ),
  };
}