import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashLogo extends StatefulWidget {
  final Widget navigateToScreen;
  SplashLogo(this.navigateToScreen);
  @override
  _SplashLogoState createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: widget.navigateToScreen,
      image: Image.asset("assets/Images/Untitled.png"),
      backgroundColor: Colors.black,
      photoSize: 100,
      loaderColor: Colors.red,
    );
  }
}
