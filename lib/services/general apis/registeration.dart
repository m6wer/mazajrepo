import 'dart:convert';
import 'dart:io';
import 'package:Mazaj/model/registerModel.dart';
import 'package:Mazaj/screens/auth/signup_page.dart';
import 'package:Mazaj/widgets/dialogs/verificationCode_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'push_notifications.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:dio/dio.dart';
import '../../constants/globals.dart' as globals;

Future signupApi({
  BuildContext context,
  var stcNo,
  String phoneNo,
  // String email,
  String gender = 'male',
  String carNo,
  String name,
  String idNo,
  File profilePic,
  File idPic,
  File contractPic,
  File licensePic,
  File carFrontPic,
  File carBackPic,
}) async {
  print('here');
  try {
    signupPageState.setState(() {
      loadingRegisteration = true;
    });
    List<int> profiePicBytes;
    String profiePic64;
    List<int> idPicBytes;
    String idPic64;
    List<int> contractPicBytes;
    String contractPic64;
    List<int> licnsePicBytes;
    String licnsePic64;
    List<int> carFrontPicBytes;
    String carFrontPic64;
    List<int> carBackPicBytes;
    String carBackPic64;

    print(profiePic64);
    print('here2');
    if (profilePic != null) {
      profiePicBytes = await profilePic.readAsBytesSync();
      profiePic64 = await base64Encode(profiePicBytes);
    }
    if (idPic != null) {
      idPicBytes = await idPic.readAsBytesSync();
      idPic64 = await base64Encode(idPicBytes);
    }
    if (contractPic != null) {
      contractPicBytes = await contractPic.readAsBytesSync();
      contractPic64 = await base64Encode(contractPicBytes);
    }
    if (licensePic != null) {
      licnsePicBytes = await licensePic.readAsBytesSync();
      licnsePic64 = await base64Encode(licnsePicBytes);
    }
    if (carFrontPic != null) {
      carFrontPicBytes = await carFrontPic.readAsBytesSync();
      carFrontPic64 = await base64Encode(carFrontPicBytes);
    }
    if (carBackPic != null) {
      carBackPicBytes = await carBackPic.readAsBytesSync();
      carBackPic64 = await base64Encode(carBackPicBytes);
    }

    ////////////////////////////////////////////////
    final SharedPreferences prf = await SharedPreferences.getInstance();
    var idNumber = int.parse(idNo);
    assert(idNumber is int);
    Dio dio = Dio();
    RegisterModel registerModel = RegisterModel(
      car: Car(
        backImg: carBackPic == null ? null : carBackPic64,
        frontImg: carFrontPic == null ? null : carFrontPic64,
        formImg: contractPic == null ? null : contractPic64,
        licenseImg: licensePic == null ? null : licnsePic64,
      ),
      carNumber: carNo,
      stcpay: stcNo == 'null' ? null : '966'+stcNo,
      // email: email,
      name: name,
      gender: gender,
      idCardImage: idPic == null ? null : idPic64,
      idNumber: idNumber.toString(),
      image: profilePic == null ? null : profiePic64,
      phone: phoneNo.trim(),
      typeRole: 'driver',
    );
    print(phoneNo);
    print(profiePic64);
    print(carBackPic64);
    print(carFrontPic64);
    print(contractPic64);
    // print(email);
    print(name);
    print(idNumber);
    print(gender);
    print(idPic64);
    print(json.encode(registerModel));
    ////////////////////////////////////////////////
    Response response = await dio
        .post(globals.apiUrl + 'general/auth/register',
            options: Options(headers: {
              "Accept": "application/json",
            }),
            data: registerModel)
        .then((response) {
      if (response.statusCode == 200) {
        print(response.data);
        print('hhh lol');
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return VerificationCodeDialog(
                phone: phoneNo,
              );
            });
        // User logedInUser = User.fromJson(jsonDecode(response.body)["user"]);
        // prf.setString(
        //     'token', jsonDecode(response.body)["token"]['access_token']);
        // prf.setString('role', jsonDecode(response.body)['user']['role']);
        // prf.setString('user', json.encode(logedInUser.toJson()));
      } else {
        print(response.data);
        return Future.error(jsonDecode(response.data));
      }
    });
    signupPageState.setState(() {
      loadingRegisteration = false;
    });
    print(response.data);
  } catch (e) {
    signupPageState.setState(() {
      loadingRegisteration = false;
    });
    return Future.error(e.toString());
  }
}
