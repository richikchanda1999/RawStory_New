import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/Auth.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String callbackUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthBLoC()
        .getAdmiralAuthURL()
        .then((value) {
          print(value);
          callbackUrl = value;
          setState(() {

          });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: callbackUrl == null || callbackUrl == ""
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(builder: (context) {
              print(callbackUrl);
              return WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: AuthBLoC().callbackURL,
                onWebViewCreated: (_) {
                  AuthBLoC().webViewController = _;
                },
                onPageStarted: (_) {
                  print(_);
                },
              );
            }),
    );
  }
}
