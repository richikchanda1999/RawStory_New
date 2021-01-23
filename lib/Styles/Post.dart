import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin PostPageStyle {
  TextStyle get headlineStyle =>
      TextStyle(fontSize: 50.ssp, fontFamily: 'Oswald');
  Map<String, Style> descriptionStyle(double fontSize) => {
        "html": Style(
            fontFamily: 'PTSerif',
            fontSize: FontSize(30.ssp * (0.35 + fontSize)),
            whiteSpace: WhiteSpace.NORMAL,
            margin: EdgeInsets.zero),
      };
}
