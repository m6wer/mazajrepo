import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/screens/maps_page.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/globals.dart' as globals;
import 'package:dio/dio.dart';

driverUpdateOrderStatusPriceApi({
  String typePayment,
  Data order,
  BuildContext context,
}) async {
  final String authToken = await readData(key: 'token');

  String url = globals.apiUrl + 'driver/orders/${order.id}/update_status';
  String statusToSend = '';
  String totalPriceToSend = '';
  String receiptPayment = '';
  TextEditingController receiptCost = TextEditingController();
  Dio dio = new Dio();
//or works once
  dio
      .put(
    url,
    data: {
      "status": 'finished',
      'type_payment': typePayment,
      // "total_price": totalPriceToSend.toString()
    },
    options: Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {
        "Authorization": "Bearer $authToken",
        "Accept": "application/json"
      },
    ),
  )
      .then((value) async {
    if (value.statusCode == 200) {
      order.status = value.data['order']['status'];
      if (order.status == 'finished') {
        isFinishing = false;
        ShowToast.showToast(context, 'تم الانتهاء من الطلب بنجاح',
            duration: 2,
            gravity: 0,
            backgroundColor: AppColors.done.withOpacity(0.6));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => DeliveryHome(
                      landingPage: 'available',
                    )));
      } else {
        isFinishing = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => MapsPage(
                      order: order,
                    )));
      }
    }
  });
}
