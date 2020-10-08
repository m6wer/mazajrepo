// import 'dart:convert';
// import 'dart:io';
// import 'package:Mazaj/Theme/app_colors.dart';
// import 'package:Mazaj/Theme/toast.dart';
// import 'package:Mazaj/model/allorders.dart';
// import 'package:Mazaj/screens/home/home_page.dart';
// import 'package:Mazaj/screens/maps_page.dart';
// import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import '../general apis/push_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../constants/globals.dart' as globals;
// import 'package:dio/dio.dart';

// driverUpdateLocationApi({
//   Data order,
//   String longitude_driver,
//   String latitude_driver,
//   BuildContext context,
// }) async {
//   final String authToken = await readData(key: 'token');

//   String url = globals.apiUrl + 'driver/orders/${order.id}/update_location';

//   Dio dio = new Dio();
//   dio
//       .put(
//     url,
//     data: {
//       "longitude_driver": longitude_driver.toString(),
//       "latitude_driver": latitude_driver.toString(),
//     },
//     options: Options(
//       headers: {
//         "Authorization": "Bearer $authToken",
//         "Accept": "application/json"
//       },
//     ),
//   )
//       .then((value) {
//     print('HLELHRLAKJSDALKJBFLASF\n');
//     print(value.data['order']);
//     print('KASDBAKSFBASKJFBAKFSJBFKABJSF');
//   });

//   // String jsonBody = json.encode(body);
//   // var response = await put(
//   //   url,
//   //   headers: {
//   //     "Accept": "application/json",
//   //     "Authorization": "Bearer $authToken",
//   //     "Content-Type": "application/x-www-form-urlencoded"
//   //   },
//   //   body: jsonBody,
//   //   encoding: Encoding.getByName("utf-8"),
//   // );
//   // if (response.statusCode == 200) {
//   //   print('updated Status and price');
//   // } else {
//   //   print(response.body);
//   //   print(response.statusCode);
//   //   // ShowToast.showToast(context, 'برجاء فتح مكاني الحالي',
//   //   //     duration: 2,
//   //   //     gravity: 0,
//   //   //     backgroundColor: AppColors.rejected.withOpacity(0.6));
//   // }
// }
