import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/globals.dart' as globals;

Future getallnotificationsApi({BuildContext context}) async {
  final prf = await SharedPreferences.getInstance();
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = prf.getString('token');
  String url = globals.apiUrl + 'general/notifications';
  
    await get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }).then((value) {
      if (value.statusCode == 200) {
        print('got all notifications');
      }
    });
}

Future deleteallnotificationsApi({BuildContext context}) async {
  final prf = await SharedPreferences.getInstance();
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = prf.getString('token');
  String url = globals.apiUrl + 'general/notifications_delete';
  
    await delete(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }).then((value) {
      if (value.statusCode == 200) {
        print('deleted all notifications');
      }
    });
  
}

Future getnotificationsbyidApi({BuildContext context}) async {
  final prf = await SharedPreferences.getInstance();
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = prf.getString('token');
  String url = globals.apiUrl + 'general/readNotification/id';
  
    await get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }).then((value) {
      if (value.statusCode == 200) {
        print('got notifications by id');
      }
    });
 
}
