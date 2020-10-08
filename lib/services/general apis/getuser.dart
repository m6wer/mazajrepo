import 'dart:convert';
import 'package:Mazaj/screens/wallet_page.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:http/http.dart';
import 'package:Mazaj/constants/globals.dart' as globals;

getUser() async {
  walletPageState.setState(() {
    walletload = false;
  });
  // String mobile_token = await PushNotificationService().getToken();
  String token = await readData(key: 'token');
  print('token $token');
  final response = await get(globals.apiUrl + 'general/auth/user', headers: {
    "Accept": "application/json",
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    walletPageState.setState(() {
      wallet = json.decode(response.body)['user']['driver']['wallet'];
      print(wallet);
      walletload = true;
    });
  } else {
    walletPageState.setState(() {
      walletload = true;
    });
  }
}
