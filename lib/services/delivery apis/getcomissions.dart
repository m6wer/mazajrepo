import 'dart:convert';
import 'package:Mazaj/model/comission.dart';
import 'package:Mazaj/screens/app_fees.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../constants/globals.dart' as globals;

getcomissionsApi({
  BuildContext context,
}) async {
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');
  print(authToken);
  String url = globals.apiUrl + 'driver/commission';
  // print(authToken);
  await get(url, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $authToken",
  }).then((value) async {
    if (value.statusCode == 200) {
      try {
        print(value.body);
        comissionList.clear();
        List tempAvailableComissions = json.decode(value.body)['orders'];
        List<Orders> comissionsTemp = [];
        for (var i = 0; i < tempAvailableComissions.length; i++) {
          String month = '';
          if (tempAvailableComissions[i]['month'] == '1') {
            month = 'يناير';
          } else if (tempAvailableComissions[i]['month'] == '2') {
            month = 'فبراير';
          } else if (tempAvailableComissions[i]['month'] == '3') {
            month = 'مارس';
          } else if (tempAvailableComissions[i]['month'] == '4') {
            month = 'ابريل';
          } else if (tempAvailableComissions[i]['month'] == '5') {
            month = 'مايو';
          } else if (tempAvailableComissions[i]['month'] == '6') {
            month = 'يونيو';
          } else if (tempAvailableComissions[i]['month'] == '7') {
            month = 'يوليو';
          } else if (tempAvailableComissions[i]['month'] == '8') {
            month = 'اغسطس';
          } else if (tempAvailableComissions[i]['month'] == '9') {
            month = 'سبتمير';
          } else if (tempAvailableComissions[i]['month'] == '10') {
            month = 'أكتوبر';
          } else if (tempAvailableComissions[i]['month'] == '11') {
            month = 'نوفمبر';
          } else if (tempAvailableComissions[i]['month'] == '12') {
            month = 'ديسمير';
          }
          comissionsTemp.add(Orders(
            commission: tempAvailableComissions[i]['commission'],
            date: tempAvailableComissions[i]['date'],
            day: tempAvailableComissions[i]['day'],
            month: month,
            year: tempAvailableComissions[i]['year'],
          ));
          for (var i = 0; i < comissionsTemp.length; i++) {
            comissionList.add(comissionsTemp[i]);
          }
          appFeesPageState.setState(() {
            loadingComission = true;
          });
        }
      } catch (e) {
        print(e);
        appFeesPageState.setState(() {
          loadingComission = false;
        });
      }
    } else {
      print(value.statusCode);
      appFeesPageState.setState(() {
        loadingComission = false;
      });
    }
  });
}
