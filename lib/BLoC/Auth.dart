import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class AuthBLoC {
  static final AuthBLoC auth = AuthBLoC._internal();
  static String _apiKey, _apiSecret, _endPointURL;
  static Uri _endpointURI;

  static String _callbackURL, _sessionID;

  static WebViewController _webViewController;
  factory AuthBLoC() {
    return auth;
  }

  AuthBLoC._internal() {
    _apiKey = "rawstory-ae37efd7cf49afb6c8a9";
    _apiSecret =
        "2yae37efd7cf49afb6c8a900014ad3e2b3de27045326b6790aa7f94697f3ce25a69b6fedf8";
    _endPointURL = "https://accounts.api.getadmiral.com/";
    _endpointURI = Uri.parse(_endPointURL);
  }

  String get callbackURL => _callbackURL;

  set webViewController(WebViewController _) {
    _webViewController = _;
  }

  Future<String> getAdmiralAuthURL() async {
    if(_callbackURL != null) return callbackURL;

    Map<String, dynamic> args = Map();

    args['method'] = "GetAdmiralAuthURL";
    args['jsonrpc'] = "2.0";
    args['params'] = {
      "apiKey": _apiKey,
      "apiKeySecret": _apiSecret,
      "createSession": true
    };

    var req = await http.post(_endpointURI,
        headers: {"Content-Type": "application/json"}, body: json.encode(args));
    if (req.statusCode == 200) {
      var res = json.decode(req.body);

      _callbackURL = res['result']['url'];
      _sessionID = res['result']['sessionID'];

      return _callbackURL;
    }
  }
}

//2-44783ae8b3686178-d0394eda-a1c8-11ea-85b3-18cb0f24aee1
//2-9d3f4a6c3129b960-134e28e5-a1c9-11ea-8dd2-fa2edd5c13f5