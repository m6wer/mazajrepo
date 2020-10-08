import 'dart:convert';
import 'dart:math';
import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/globals.dart' as globals;
import 'package:Mazaj/screens/home/tabs/available_orders.dart';

Future drivertakeorderApi({
  BuildContext context,
  String longitude_drive,
  String latitude_driver,
  String id_order,
  String address_driver,
  Data order,
}) async {
  final prf = await SharedPreferences.getInstance();
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');
  // print(authToken);
  String url = globals.apiUrl + 'driver/orders/$id_order/takeOrder';

  // Calculating the total distance by adding the distance
  // between small segments
  double _distanceOfDriver(
      {double lat1, double lon1, double lat2, double lon2}) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double deliveryCost = 0;
  print('Client: ${order.latitude}, ${order.longitude}');
  print('Delivery: $longitude_drive, $latitude_driver');
  deliveryCost = _distanceOfDriver(
    lat1: double.parse(latitude_driver),
    lon1: double.parse(longitude_drive),
    lat2: double.parse(order.latitude),
    lon2: double.parse(order.longitude),
  );
  print('delivery cost= $deliveryCost');
  // if (deliveryCost > 8) {
  //   deliveryCost = globals.deliveryCost.toDouble() + ((deliveryCost - 8));
  // } else {
  //   deliveryCost = globals.deliveryCost.toDouble();
  // }
  String driver_price = deliveryCost.floor().toString();
  print('Total Distance: $deliveryCost');
  print('Driver Price: $driver_price');
  await get(
    url,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    },
    //  body: {
    //   // 'longitude_driver': longitude_drive.toString(),
    //   // 'latitude_driver': latitude_driver.toString(),
    //   // 'address_driver': address_driver.toString(),
    //   // 'driver_price': driver_price,
    // },
  ).then((value) {
    if (value.statusCode == 200) {
      print('took order');
      availableOrderList.clear();
      print(value.body);
      if (jsonDecode(value.body)['message'] == 'Order Rejected') {
        ShowToast.showToast(context, 'هذا الطلب مقبول بالفعل',
            duration: 2,
            gravity: 0,
            backgroundColor: AppColors.rejected.withOpacity(0.6));
      } else {
        ShowToast.showToast(context, 'تم قبول الطلب بنجاح',
            duration: 2,
            gravity: 0,
            backgroundColor: AppColors.done.withOpacity(0.6));
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DeliveryHome(
                    landingPage: 'ongoing',
                  )));
    } else {
      print(value.body);
      print(value.statusCode);
      ShowToast.showToast(context, 'برجاء فتح مكاني الحالي',
          duration: 2,
          gravity: 0,
          backgroundColor: AppColors.rejected.withOpacity(0.6));
    }
  });
}
