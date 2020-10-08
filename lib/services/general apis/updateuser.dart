import 'dart:convert';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/main.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/globals.dart' as globals;
import '../../model/deliveryuser.dart';

Future updateuserApi(
    {String image64,
    String phone,
    String type,
    String stcpay,
    BuildContext context}) async {
  String token = await readData(key: 'token');
  print(token);
  Map body = {};
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  print(deliveryUserInfo.name.toString());
  // print(deliveryUserInfo.email);
  print(phone);
  print(stcpay);
  print(deliveryUserInfo.imagePath);
  print(json.encode(deliveryUserInfo));
  if (type == 'phone') {
    body = {
      'name': deliveryUserInfo.name,
      'phone': '966' + phone,
      'stcpay': null,
      // 'image': image64.toString(),
    };
  } else if (type == 'stcpay') {
    print('stcpay');
    body = {
      'name': deliveryUserInfo.name,
      'phone': deliveryUserInfo.phone,
      'stcpay': '966' + stcpay,
      // 'image': image64.toString(),
    };
  } else {
    body = {
      'name': deliveryUserInfo.name,
      'phone': deliveryUserInfo.phone,
      'stcpay': deliveryUserInfo.stcpay,
      'image': image64.toString(),
    };
  }
  final response = await http.put(globals.apiUrl + 'general/auth/UpdateUser',
      headers: headers, body: jsonEncode(body));
  print(response.body);
  if (response.statusCode == 200) {
    if (type == 'image') {
      ShowToast.showToast(context, "تم تغيير الصورة بنجاح",
          backgroundColor: Color(0xFF2C6500),
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    } else if (type == 'stcpay') {
      deliveryUserInfo.stcpay = json.decode(response.body)['user']['stcpay'];
      ShowToast.showToast(context, "بنجاح stcpay تم تغيير رقم",
          backgroundColor: Color(0xFF2C6500),
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    } else {
      ShowToast.showToast(context, "تم تغيير رقم الهاتف بنجاح",
          backgroundColor: Color(0xFF2C6500),
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    }
    deliveryUserInfo.image = json.decode(response.body)['user']['image_path'];
    print(deliveryUserInfo.image);
    print(deliveryUserInfo.phone);
    if (type == 'phone') {
      deliveryUserInfo.phone = json.decode(response.body)['user']['phone'];
    }
    print(deliveryUserInfo.phone);
    print(deliveryUserInfo.imagePath);

    deliveryUserInfo.imagePath =
        json.decode(response.body)['user']['image_path'];
    print(deliveryUserInfo.imagePath);
    await saveData(
        key: 'user', saved: jsonEncode(jsonDecode(response.body)['user']));
    print(deliveryUserInfo.imagePath);
    print('image changed');
  } else {
    if (type == 'image') {
      ShowToast.showToast(context, "تعذر تغيير الصورة",
          backgroundColor: Colors.red,
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    } else if (type == 'stcpay') {
      ShowToast.showToast(context, "stcpay تعذر تغيير رقم",
          backgroundColor: Colors.red,
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    } else {
      ShowToast.showToast(context, "تعذر تغيير رقم الهاتف",
          backgroundColor: Colors.red,
          duration: 3,
          gravity: 0,
          textColor: Colors.white);
    }
    print(response.statusCode);
    //tyb yasta enta bt3ml validate 3la eh bzbt
    //mstneek, aywa mna sm3tk yasta ana mstny n3ml eh

  }
}
