import 'package:Mazaj/screens/auth/login_page.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:Mazaj/widgets/customDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'push_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../constants/globals.dart' as globals;

Future signoutApi({BuildContext context}) async {
  final prf = await SharedPreferences.getInstance();
  final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');
  print(authToken);
  await post(globals.apiUrl + 'general/auth/logout', headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $authToken",
  }).then((value) {
    if (value.statusCode == 200) {
      isLoggingOut = false;
      print('5arag');
      prf.remove('token');
      prf.remove("user");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    } else {
      print(value.body);
    }
  });
}
