import 'dart:convert';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/screens/auth/signup_page.dart';
import 'package:Mazaj/widgets/dialogs/verificationCode_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../constants/globals.dart' as globals;

Future loginApi({String phoneNumber, BuildContext context}) async {
  try {
    String url = globals.apiUrl + 'general/auth/login';
    print(url);
    print(phoneNumber);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    Response response = await post(
      url,
      headers: headers,
      body: {
        "phone": '966' + phoneNumber,
      },
    );
    if (response.statusCode == 200) {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return VerificationCodeDialog(
              phone: "966" + phoneNumber,
            );
          });
    } else if (response.statusCode == 422) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => SignupPage(
                    phoneNo: '966' + phoneNumber,
                  )));
    } else {
      print(response.statusCode);
      print(response.body);
      ShowToast.showToast(context, response.body,
          duration: 5, gravity: 1, backgroundColor: Colors.black);

      return Future.error(jsonDecode(response.body)['message']);
    }
  } catch (e) {
    print(e);
  }
}

// loginData({String phone, BuildContext context}) async {
//   var status;
//   var data;
//   // String myUrl = "${globals.apiUrl}auth/login";
//   final response =
//       await post('http://test.paraksa.com/ar/api/general/auth/login', headers: {
//     'Accept': 'application/json'
//   }, body: {
//     "phone": '966' + phone,
//   });
//   if (response.statusCode == 200) {
//     showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (BuildContext context) {
//           return VerificationCodeDialog(
//             phone: phone,
//           );
//         });
//   }
//   status = response.body.contains('error');
//   data = json.decode(response.body);
//   print(data);
// }
