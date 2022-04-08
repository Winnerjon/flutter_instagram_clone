import 'dart:convert';

import 'package:http/http.dart';


class HttpService {
  static String SERVER = "fcm.googleapis.com";

  /* Header */
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAAOkoH4Rw:APA91bERldELTwx5jI-_Mlg7N4WFZkHWCRNMLcibHX_78rrew2LfIE2-K1Z4Af-MWdDugJv5T0_GE5AajmgmVBzcuZPT-95_rkmNCp8vOoVAngtShXQp5cPLiFBg3oVSeftrFnO8WPXr"
  };

  static String API_CREATE = "/fcm/send";

  static Future<String?> POST(Map<String, dynamic> params) async {
    var uri = Uri.https(SERVER, API_CREATE); // http or https
    var response = await post(
      uri,
      body: jsonEncode(params),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) return response.body;
    return null;
  }

  static Map<String, dynamic> paramsCreate(String token,String userName,String someoneName) {
    Map<String, dynamic> params = {};
    params.addAll({
      "notification": {
        "title": "My Instagram $someoneName",
        "body": "$userName followed you!"
      },
      "registration_ids": [token],
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    });
    return params;
  }
}
