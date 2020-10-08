import 'dart:convert';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/tabs/accepted_orders.dart';
import 'package:Mazaj/screens/home/tabs/available_orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../general apis/sharedPreference.dart';
import '../../constants/globals.dart' as globals;

String nextPageUrl;
int counter = 1;
driverallordersApi(
    {BuildContext context,
    String status,
    bool paginate = false,
    String pagination}) async {
  // final String messagesToken = await PushNotificationService().getToken();
  final String authToken = await readData(key: 'token');
  print(authToken);
  print(pagination);
  String url = globals.apiUrl + 'driver/orders?status=$status';

  if (paginate == true) {
    if (nextPageUrl == null) {
      print('null ya5oya');
      url = globals.apiUrl + 'driver/orders?status=$status&page=$counter';
      return;
      paginate = false;
      counter = 1;
    } else {
      url = nextPageUrl;
      nextPageUrl = globals.apiUrl + 'driver/orders?status=new&page=$counter';
      counter++;
    }
  }
  // print(authToken);
  await get(url, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $authToken",
  }).then((value) async {
    if (value.statusCode == 200) {
      print('200 hena');
      List list = [];
      try {
        if (status == 'old') {
          list = acceptedOrdersList;
        } else if (status == 'new') {
          list = availableOrderList;
        }
        if (paginate == false) {
          list.clear();
        }
        print('got all orders');
        List tempAvailableOrders = json.decode(value.body)['orders']['data'];
        nextPageUrl =
            json.decode((value.body))['orders']['next_page_url'].toString();
        print(nextPageUrl);
        for (var i = 0; i < tempAvailableOrders.length; i++) {
          // User userTemp;
          // Place placeTemp;
          // Map tempAvailablePlace =
          //     await json.decode(value.body)['orders']['data'][i]['place'];
          // Map tempAvailableUser =
          //     await json.decode(value.body)['orders']['data'][i]['user'];

          List<Products> productsTemp = [];
          List tempAvailableProducts =
              await json.decode(value.body)['orders']['data'][i]['products'];
          for (var j = 0; j < tempAvailableProducts.length; j++) {
            Pivot tempPivot = Pivot(
              color: tempAvailableProducts[j]['pivot']['color'] == null
                  ? 'null'
                  : tempAvailableProducts[j]['pivot']['color'],
              quantity: tempAvailableProducts[j]['pivot']['quantity'],
            );
            await productsTemp.add(Products(
              id: tempAvailableProducts[j]['id'].toString(),
              image: tempAvailableProducts[j]['image'],
              name: tempAvailableProducts[j]['name'],
              categoryId: tempAvailableProducts[j]['category_id'],
              // colors: tempAvailableProducts[j]['colors'],
              createdAt: tempAvailableProducts[j]['created_at'],
              description: tempAvailableProducts[j]['description'],
              descriptionAr: tempAvailableProducts[j]['description_ar'],
              descriptionEn: tempAvailableProducts[j]['description_en'],
              imagePath: tempAvailableProducts[j]['image_path'],
              nameAr: tempAvailableProducts[j]['name_ar'],
              nameEn: tempAvailableProducts[j]['name_en'],
              pivot: tempPivot,
              salePrice: tempAvailableProducts[j]['sale_price'],
              stock: tempAvailableProducts[j]['stock'],
              updatedAt: tempAvailableProducts[j]['updated_at'],
              weight: tempAvailableProducts[j]['weight'],
            ));
          }
          // userTemp = User(
          //   code: tempAvailableUser['code'],
          //   createdAt: tempAvailableUser['created_at'],
          //   email: tempAvailableUser['email'],
          //   emailVerifiedAt: tempAvailableUser['email_verified_at'],
          //   id: tempAvailableUser['id'],
          //   image: tempAvailableUser['image'],
          //   imagePath: tempAvailableUser['image_path'],
          //   mobileToken: tempAvailableUser['mobile_token'],
          //   name: tempAvailableUser['name'],
          //   phone: tempAvailableUser['phone'],
          //   updatedAt: tempAvailableUser['updated_at'],
          // );
          // placeTemp = Place(
          //   address: tempAvailablePlace['address'],
          //   id: tempAvailablePlace['id'].toString(),
          //   idPlace: tempAvailablePlace['id_place'],
          //   image: tempAvailablePlace['image'],
          //   latitude: tempAvailablePlace['latitude'].toString(),
          //   longitude: tempAvailablePlace['longitude'].toString(),
          //   name: tempAvailablePlace['name'],
          // );
          await list.add(Data(
            products: productsTemp,
            transactionNo: tempAvailableOrders[i]['transactionNo'].toString(),
            driverPrice: tempAvailableOrders[i]['driver_price'].toString(),
            address: tempAvailableOrders[i]['address'],
            createdAt: tempAvailableOrders[i]['created_at'],
            driverId: tempAvailableOrders[i]['driver_id'].toString(),
            id: tempAvailableOrders[i]['id'].toString(),
            typePayment: tempAvailableOrders[i]['type_payment'].toString(),
            latitude: tempAvailableOrders[i]['latitude'],
            longitude: tempAvailableOrders[i]['longitude'],
            name: tempAvailableOrders[i]['name'],
            note: tempAvailableOrders[i]['note'],
            phone: tempAvailableOrders[i]['phone'],
            status: tempAvailableOrders[i]['status'],
            totalPrice: tempAvailableOrders[i]['total_price'],
            updatedAt: tempAvailableOrders[i]['update_at'],
          ));
          tempAvailableProducts.clear();
          // tempAvailableUser.clear();
          // print(json.encode(placeTemp));
        }
      } catch (e) {
        print(e);
      }
    } else {
      print(value.statusCode);
    }
  });
}
