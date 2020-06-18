import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin PostPageStyle {
  TextStyle get headlineStyle => TextStyle(color: Colors.white, fontSize: 50.ssp);
  Map<String, Style> get descriptionStyle => {
    "html": Style(
      color: Colors.white
    ),
  };
}