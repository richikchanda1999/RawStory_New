import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsletterBloc {
  NewsletterBloc._privateConstructor();
  static final NewsletterBloc newsletterBloc =
      NewsletterBloc._privateConstructor();

  factory NewsletterBloc() {
    return newsletterBloc;
  }

  String postUpEmail = "adeeb@rawstory.com";
  String postUpPass = "4wz!NK3qfWqy6Yn";
  int listId = 450;

  Future<int> createRecipient(String emailId) async {
    String endPoint = "https://api.postup.com/api/recipient";
    var bytes = utf8.encode("$postUpEmail:$postUpPass");
    var base64str = base64.encode(bytes);
    var headers = {"authorization": "Basic $base64str"};

    var body = jsonEncode(<String, String>{
      "address": emailId,
      "externalId": emailId,
      "channel": "E",
      "sourceDescription": "RawStory App"
    });
    http.Response response =
        await http.post(endPoint, headers: headers, body: body);

    var resBody = json.decode(response.body);
    print(resBody);
    if (resBody.isNotEmpty) {
      if (resBody["recipientId"]!=null)
        return resBody["recipientId"];
      else
        return -1;
    } else {
      return -1;
    }
  }

  Future<bool> subscribeRecipientToList(int recipientId) async {
    String endPoint = "https://api.postup.com/api/listsubscription";
    var bytes = utf8.encode("$postUpEmail:$postUpPass");
    var base64str = base64.encode(bytes);
    var headers = {"authorization": "Basic $base64str"};

    var body = jsonEncode(<String, String>{
      "listId": listId.toString(),
      "recipientId": recipientId.toString(),
      "status": "NORMAL"
    });
    http.Response response =
        await http.post(endPoint, headers: headers, body: body);

    var resBody = json.decode(response.body);
    print(resBody);
    if (resBody.isNotEmpty) {
      if (resBody["recipientId"] !=null)
        return true;
      else
        return false;
    } else {
      return false;
    }
  }

  Future<int> fetchRecipientId(String usrEmail) async {
    String recEndpoint =
        "https://api.postup.com/api/recipient?address=$usrEmail";
    var bytes = utf8.encode("$postUpEmail:$postUpPass");
    var base64str = base64.encode(bytes);
    var headers = {"authorization": "Basic $base64str"};

    http.Response response = await http.get(recEndpoint, headers: headers);

    var body = json.decode(response.body);
    print(body);
    if (body.isEmpty)
      return -1;
    else
      return body[0]["recipientId"];
  }
}
