import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin HomeStyle {
  double get bottomNavBarHeight => 70.h;
}

mixin PostCardStyle {
  TextStyle get postHeadlineStyle1 =>
      TextStyle(color: Colors.white, fontSize: 40.ssp, fontFamily: 'Oswald');
  TextStyle get postHeadlineStyle2 =>
      TextStyle(fontSize: 32.ssp, fontFamily: 'Oswald');
}
