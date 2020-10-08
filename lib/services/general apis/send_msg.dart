import 'package:Mazaj/services/general%20apis/push_notifications.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/globals.dart' as globals;

Future sendmsgApi(
    {BuildContext context,
    String toUser,
    String notificationTitle,
    String notificationBody}) async {
  final prf = await SharedPreferences.getInstance();
  final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');

  await post(
    globals.apiUrl + 'general/sendMassage',
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    },
    body: {
      'user_id_to': toUser,
      'title': notificationTitle,
      'body': notificationBody,
    },
  ).then((value) {
    if (value.statusCode == 200) {
      print('message Sent successfully');
    }
  });
}
