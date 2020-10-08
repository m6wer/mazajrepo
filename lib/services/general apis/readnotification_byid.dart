import 'package:Mazaj/services/general%20apis/push_notifications.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../constants/globals.dart' as globals;

readNotificationsById({
  BuildContext context,
  String notificationId,
}) async {
  final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');
  print(authToken);
  String url = globals.apiUrl + 'general/readNotification/id';
  // print(authToken);
  await get(url, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $authToken",
  }).then((value) async {
    if (value.statusCode == 200) {
      try {
        print(value.body);
      } catch (e) {
        print(e);
      }
    } else {
      print(value.statusCode);
    }
  });
}
