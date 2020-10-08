import 'dart:convert';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/main.dart';
import 'sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../lib/../model/deliveryuser.dart';
import '../../constants/globals.dart' as globals;

// Map userMap;
// Future<DeliveryUser> checkcodeApi(
//     {String phone, String code, BuildContext context}) async {
//   User _user;
//   String mobile_token = await PushNotificationService().getToken();
//   // print(mobile_token);
//   final SharedPreferences prf = await SharedPreferences.getInstance();
//   Response response =
//       await post(globals.apiUrl + 'general/auth/CheckCode', headers: {
//     "Accept": "application/json",
//   }, body: {
//     "phone": phone.toString(),
//     "code": code,
//     "mobile_token": mobile_token,
//   }).then((response) {
//     if (response.statusCode == 200) {
//       // print('checked done');
//       // print(code);
//       // print(mobile_token);

//       // print(jsonDecode(response.body));
//       // print(jsonDecode(response.body)['user']['roles']);
//       // print(jsonDecode(response.body)["user"]);
//       // print(jsonDecode(response.body)['access_token']);
//       // print(json.encode(jsonDecode(response.body)["user"]));
//       // User logedInUser = User.fromJson(jsonDecode(response.body)["user"]);
//       var res = jsonDecode(response.body);
//       DeliveryUser logedInUser =
//           DeliveryUser.fromJson(json.decode(response.body));
//       _user = User.fromJson(res["user"]);

//       SharedPreferences.getInstance().then((prefs) {
//         // prefs.setString('user', json.encode(logedInUser));
//         // prefs.setString('token', jsonDecode(logedInUser.accessToken));
//         print(json.decode((response.body))['user']);
//         print('loged in user: ' + json.encode(logedInUser.user));
//         prefs.setString('user', json.decode((response.body))['user']);
//         prefs.setString('token', json.decode((response.body))['access_token']);
//         print(prefs.getString('user'));
//         DeliveryUser user =
//             DeliveryUser.fromJson(jsonDecode(prefs.getString('user')));
//         print('user is: ' + json.encode(user));
//         // print(
//         //     'Token came back is  ' + jsonDecode(response.body)['access_token']);
//         // Navigator.pushReplacementNamed(context, '/home');
//         // Navigator.pushReplacement(
//         //     context, MaterialPageRoute(builder: (_) => DeliveryHome()));
//       });
//       // DeliveryUser deliveryUser =
//       //     DeliveryUser.fromJson(jsonDecode(response.body));
//       // // print('deliveryUser: ' + deliveryUser.user.toJson().toString());
//       // User user;
//       // prf.setString('user', json.encode(deliveryUser.user));
//       // user = User.fromJson(json.decode(prf.getString('user')));
//       // prf.setString('token', deliveryUser.accessToken);
//       // print(json.encode(user));
//       // return DeliveryUser.fromJson(json.decode(response.body));
//     } else {
//       // print(response.body);
//       return Future.error(jsonDecode(response.body));
//     }
//   });
// }

Future<User> checkUserCode({
  BuildContext context,
  String phone,
  String code,
  @required String cameFrom,
}) async {
  // String mobile_token = await PushNotificationService().getToken();
  // print(mobile_token);
  print(phone);
  final response =
      await post(globals.apiUrl + 'general/auth/CheckCode', headers: {
    "Accept": "application/json",
  }, body: {
    "phone": phone.toString(),
    "code": code,
    // "mobile_token": mobile_token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('response = 200');
    await saveData(
        saved: jsonDecode(response.body)['access_token'], key: 'token');
    var x = await readData(key: 'token');
    print(x);
    print(jsonDecode(response.body)['user']);
    await saveData(
        key: 'user', saved: jsonEncode(jsonDecode(response.body)['user']));
    print(await readData(key: 'user'));
    String userMap = await readData(key: 'user');
    deliveryUserInfo = User.fromJson(json.decode(userMap));

    // final prefs = await SharedPreferences.getInstance();
    // Map decode_options = json.decode(response.body);
    // String user = jsonEncode(User.fromJson(decode_options['user']));
    // prefs.setString('user', user);
    // await prefs.setString(
    //     'token', json.decode((response.body))['access_token']);
    // Map userMap = json.decode(prefs.getString('user'));
    // var user1 = User.fromJson(userMap);
    // // print(userMap);
    // // print(user1);
    // // print(user1);
    // return user1;
    // print(prefs.getString('token'));
    // print(x);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => DeliveryHome()));
  } else {
    ShowToast.showToast(context, "تعذر تأكيد الكود",
        backgroundColor: Colors.red,
        duration: 3,
        gravity: 0,
        textColor: Colors.white);
    print(response.body);
    return null;
    // If the server did not return a 200 OK response,
    // then throw an exception.
    // throw Exception('Failed to get user data');
  }
}
