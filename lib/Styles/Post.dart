import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin PostPageStyle {
  TextStyle get headlineStyle => TextStyle(color: Colors.black, fontSize: 60.ssp,fontFamily: 'NimbusSansT');
  Map<String, Style> get descriptionStyle => {
    "html": Style(
      color: Colors.black,
      fontSize: FontSize(32.ssp),
    ),
  };
}