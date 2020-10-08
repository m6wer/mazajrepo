import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:Mazaj/services/delivery%20apis/takeorder.dart';
import 'maps_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final Data order;
  OrderDetailsPage({this.order});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool isLoading = false;
  bool isAccepting = false;
  @override
  Widget build(BuildContext context) {
    print(widget.order.status);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DeliveryHome()));
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: AppColors.mainGreyColor,
            iconTheme: IconThemeData(color: Colors.white, size: 10),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DeliveryHome())),
            ),
            title: Text("تفاصيل الطلب",
                style: TextStyle(color: Colors.white, fontSize: 14)),
            centerTitle: true,
          ),
          persistentFooterButtons: widget.order.status ==
                  "the_request_is_being_prepared"
              ? <Widget>[
                  Container(
                    width: width,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor),
                              backgroundColor: AppColors.darkGrey,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Expanded(
                              //   child: Container(
                              //     // width: width * 0.45,
                              //     child: RaisedButton(
                              //       // onPressed: () => rejectOrAccept(
                              //       //     context: context,
                              //       //     acceptOrReject: OrderButtons.reject),
                              //       color: AppColors.rejected,
                              //       child: Text("رفض"),
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: Container(
                                    // width: width * 0.5,
                                    child: RaisedButton(
                                  onPressed: () async {
                                    // rejectOrAccept(
                                    //     context: context,
                                    //     acceptOrReject: OrderButtons.accept),
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
                                      isAccepting = false;
                                    });
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (BuildContext context) =>
                                    //           DeliveryHome(),
                                    //     ));
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
                                      : Text("قبول"),
                                )),
                              ),
                            ],
                          ),
                  )
                ]
              : <Widget>[
                  Container(
                    width: width,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor),
                              backgroundColor: AppColors.darkGrey,
                            ),
                          )
                        : widget.order.status == 'finished'
                            ? Container()
                            : widget.order.status == 'order_is_in_progress'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            // width: width * 0.45,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                print(widget.order.id);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MapsPage(
                                                                order: widget
                                                                    .order),
                                                        fullscreenDialog:
                                                            true));
                                              },
                                              color: AppColors.primaryColor,
                                              child: Text("متابعة"),
                                            ),
                                          ),
                                        )
                                      ])
                                : Container(),
                  ),
                ],
          body: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "معلومات الطلب",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                width: width,
              ),
              Container(
                color: AppColors.ligthGrey.withOpacity(0.09),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "العنوان",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                width: width,
              ),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        RichText(
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                              style: TextStyle(color: Colors.white),
                              text: "من     ",
                              children: [
                                TextSpan(
                                    text: "$locationString",
                                    style: TextStyle(color: AppColors.greyText))
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(
                            color: AppColors.greyText,
                            thickness: 2,
                            height: 2,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                              style: TextStyle(color: Colors.white),
                              text: "إلى     ",
                              children: [
                                TextSpan(
                                    text: "${widget.order.address}",
                                    style: TextStyle(color: AppColors.greyText))
                              ]),
                        ),
                      ],
                    ),
                  )),
              Container(
                color: AppColors.ligthGrey.withOpacity(0.09),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Text(
                    //   " العدد ${widget.order.products.length}",
                    //   style: TextStyle(color: AppColors.primaryColor),
                    //   textAlign: TextAlign.right,
                    // ),
                    Text(
                      "الطلبات",
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                height: 50,
                width: width,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    width: width * 0.9,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFFEAE805).withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.order.products.map((product) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontFamily: "GE_SS_Two"),
                                          text: "كمية   ",
                                          children: [
                                            TextSpan(
                                                style: TextStyle(
                                                    fontFamily: "Arial"),
                                                text:
                                                    "${product.pivot.quantity}")
                                          ]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${product.name}",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontFamily: "GE_SS_Two"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ],
                        );
                      }).toList(),
                    )),
              ),
              Container(
                color: AppColors.ligthGrey.withOpacity(0.09),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "قيمة الطلب",
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                height: 50,
                width: width,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${widget.order.driverPrice == 'null' || widget.order.driverPrice == null ? 0 : widget.order.driverPrice} SAR ",
                            style: TextStyle(fontFamily: "Roboto"),
                          ),
                          Text("قيمة التوصيل"),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            // todo dilvery price
                            widget.order.totalPrice.toString() == 'null'
                                ? '0 SAR'
                                : widget.order.totalPrice.toString() + " SAR",
                            style: TextStyle(fontFamily: "Roboto"),
                          ),
                          Text("قيمة المشتريات"),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.greyText,
                      thickness: 2,
                      height: 2,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              // todo dilvery price
                              widget.order.totalPrice == 'null'
                                  ? '0' + ' SAR'
                                  : (double.parse(widget.order.driverPrice
                                                          .toString() ==
                                                      'null'
                                                  ? '0'
                                                  : widget.order.driverPrice
                                                      .toString()) +
                                              double.parse(widget
                                                  .order.totalPrice
                                                  .toString()))
                                          .toString() +
                                      " SAR",
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Color(0xFF85EC85)),
                            ),
                            Text(
                              "إجمالى",
                              style: TextStyle(color: Color(0xFF85EC85)),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
