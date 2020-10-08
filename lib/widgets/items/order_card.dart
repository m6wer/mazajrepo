import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/screens/orderDetails_page.dart';
import 'package:Mazaj/services/delivery%20apis/takeorder.dart';
import 'package:dotted_line/dotted_line.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/globals.dart' as globals;

class OrderCard extends StatefulWidget {
  final Data order;
  final Function refreshOrers;
  final Function startLoading;
  final Function stopLoading;
  final int index;
  // final String mylongitude, mylatitude;
  OrderCard({
    @required this.index,
    this.refreshOrers,
    this.startLoading,
    this.stopLoading,
    this.order,
    // this.mylatitude,
    // this.mylongitude,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isLoading = false;
  bool isAccepting = false;
  Color orderColors() {
    String status = widget.order.status;
    switch (status) {
      case "the_request_is_being_prepared":
        {
          return AppColors.lightFont;
        }
        break;

      // case "قيد التحضير":
      //   {
      //     return AppColors.done;
      //   }
      //   break;
      case "order_is_in_progress":
        {
          return AppColors.done;
        }
        break;
      // case "جاري توصيل الطلب":
      //   {
      //     return AppColors.secondaryColor;
      //   }
      // break;
      case "finished":
        {
          return AppColors.secondaryColor;
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
    return Colors.blue;
  }

  // void rejectOrAccept(
  //     {BuildContext context, OrderButtons acceptOrReject}) async {
  //   try {
  //     widget.startLoading();
  //     bool result = await HomeRepo().acceptOrRejectOrder(
  //         orderId: widget.order.id, acceptOrReject: acceptOrReject);
  //     if (result) {
  //       print("تم اضافه الطلب بنجاح");
  //       widget.refreshOrers();
  //     } else {}
  //   } catch (e) {
  //     print(e.toString());
  //     ShowToast.showToast(context, e.toString());
  //   } finally {
  //     widget.stopLoading();
  //   }
  // }
  String client_distance = '0';
  Future<String> _coordinateDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return ((12742 * asin(sqrt(a)))).toStringAsFixed(2);
  }

  initialize() async {
    print('INIINININININIIN' + client_distance.toString());
    print(widget.order.latitude);
    print(widget.order.longitude);
    String tempDistance = await _coordinateDistance(
      24.778230,
      46.689261,
      double.parse(widget.order.latitude),
      double.parse(widget.order.longitude),
    );
    setState(() {
      client_distance = tempDistance;
    });
    print('OUTUTUTUTUTOUTHTOUUOSBUOSBO' + client_distance.toString());
  }

  String driverDistance = '0';
  Future<String> _coordinateDistance2(
      double lat1, double lon1, double lat2, double lon2) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return ((12742 * asin(sqrt(a)))).toStringAsFixed(2);
  }

  initialize2() async {
    print('INIINININININIIN' + driverDistance.toString());
    print(widget.order.latitude);
    print(widget.order.longitude);
    print(latitudeDriver);
    print(longitudeDriver);

    String tempDistance = await _coordinateDistance2(
      double.parse(latitudeDriver),
      double.parse(longitudeDriver),
      double.parse(widget.order.latitude),
      double.parse(widget.order.longitude),
    );
    String tempDistance2 = await _coordinateDistance2(
      double.parse(latitudeDriver),
      double.parse(longitudeDriver),
      24.778230,
      46.689261,
    );
    setState(() {
      driverDistance = tempDistance2;
    });
    // if (double.parse(tempDistance) > 8) {
    //   double tempDeliveryPrice =
    //       (double.parse(tempDistance) - 8) + globals.deliveryCost.toDouble();
    //   setState(() {
    //     print('tempDeliveryPrice $tempDeliveryPrice');
    //     widget.order.driverPrice = tempDeliveryPrice.toString();
    //   });
    // } else {
    //   int tempDeliveryPrice = globals.deliveryCost;
    //   setState(() {
    //     widget.order.driverPrice = tempDeliveryPrice.toString();
    //   });
    // }
    print('OUTUTUTUTUTOUTHTOUUOSBUOSBO' + driverDistance.toString());
  }

  @override
  void initState() {
    initialize();
    initialize2();
    // calculateDistance();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      child: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(order: widget.order)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Stack(
            children: <Widget>[
              Container(
                height: height * 0.275,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blueGrey,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black87, spreadRadius: 2, blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Center(
                            child: ListTile(
                          dense: true,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: width * 0.4,
                                child: Text(
                                  "Mazaj Asly",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ),
                              Text(
                                "${widget.order.driverPrice == 'null' ? 0 : widget.order.driverPrice} SAR ",
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontFamily: "Arial",
                                    color: AppColors.price),
                              ),
                            ],
                          ),
                          // leading: ClipRRect(
                          //   borderRadius: BorderRadius.circular(40.0),
                          //   //place with image and name here
                          //   child: CachedNetworkImage(
                          //       fit: BoxFit.cover,
                          //       width: 50,
                          //       height: 50,
                          //       placeholder: (context, url) =>
                          //           Image.asset("assets/images/logo.png"),
                          //       imageUrl: (widget.order.place.image != null)
                          //           ? widget.order.place.image
                          //           : ""),
                          // ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: width * 0.4,
                                child: Text(
                                  "${widget.order.products.length == 0 ? "لا يوجد منتجات " : widget.order.products.first.name}... ",
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "رقم الطلب :${widget.order.id}",
                                    style: TextStyle(fontFamily: "Arial"),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // onTap: () {}),
                        )),
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 30,
                        left: 30,
                        top: 25,
                      ),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30.0, 0, 30, 10),
                          margin: EdgeInsetsDirectional.only(bottom: 15),
                          height: 60,
                          width: width,
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/car-side.svg",
                                    color: AppColors.primaryColor,
                                    height: 20,
                                  ),
                                  Text("المندوب")
                                ],
                              ),
                              Flexible(
                                  child: DottedLine(
                                dashColor: Colors.white,
                                dashLength: 1.0,
                              )),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/map_pin.svg",
                                    color: AppColors.lightFont,
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    //put here distance between driver and store
                                    "$driverDistance km",
                                    style: TextStyle(
                                        fontFamily: "Arial",
                                        fontSize: 12,
                                        color: AppColors.lightFont),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: DottedLine(
                                dashColor: Colors.white,
                                dashLength: 1.0,
                              )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/store.svg",
                                    color: AppColors.primaryColor,
                                    height: 20,
                                  ),
                                  Text("المتجر")
                                ],
                              ),
                              Flexible(
                                  child: DottedLine(
                                dashColor: Colors.white,
                                dashLength: 1.0,
                              )),
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/map_pin.svg",
                                    color: AppColors.lightFont,
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    //put here distance between store and client
                                    "$client_distance km",
                                    style: TextStyle(
                                        fontFamily: "Arial",
                                        fontSize: 12,
                                        color: AppColors.lightFont),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: DottedLine(
                                dashColor: Colors.white,
                                dashLength: 1.0,
                              )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    "assets/images/home.svg",
                                    color: AppColors.primaryColor,
                                    height: 20,
                                  ),
                                  Text("العميل")
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.yellow,
                  height: 25,
                  child: widget.order.status != "processing"
                      ? Container(
                          height: 25,
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          width: width * 0.9,
                          color: orderColors(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${widget.order.id}",
                                style: TextStyle(fontFamily: "arial"),
                              ),
                              Text(widget.order.status ==
                                      'the_request_is_being_prepared'
                                  ? 'جاري تحضير الطلب'
                                  : widget.order.status ==
                                          'order_is_in_progress'
                                      ? 'جاري توصيل الطلب'
                                      : 'تمت'),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   width: width * 0.45,
                            //   child: RaisedButton(
                            //     onPressed: () {},
                            //     color: AppColors.rejected,
                            //     child: Text("رفض"),
                            //   ),
                            // ),
                            Container(
                                width: width * 0.85,
                                child: RaisedButton(
                                  onPressed: () async {
                                    // rejectOrAccept(
                                    //     context: context,
                                    //     acceptOrReject: OrderButtons.accept);
                                    setState(() {
                                      isAccepting = true;
                                    });
                                    await drivertakeorderApi(
                                      order: widget.order,
                                      address_driver: addressDriver,
                                      context: context,
                                      id_order: widget.order.id.toString(),
                                      latitude_driver: latitudeDriver,
                                      longitude_drive: longitudeDriver,
                                    );
                                    setState(() {
                                      isAccepting = true;
                                    });
                                  },
                                  color: AppColors.done,
                                  child: isAccepting
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.primaryColor),
                                            backgroundColor: AppColors.darkGrey,
                                          ),
                                        )
                                      : Center(child: Text("قبول")),
                                )),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
