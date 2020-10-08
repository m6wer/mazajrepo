import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/screens/home/tabs/available_orders.dart';
import 'package:Mazaj/screens/home/tabs/accepted_orders.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:Mazaj/widgets/customDrawer.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import '../LocationPiker_page.dart';

class DeliveryHome extends StatefulWidget {
  final String landingPage;
  DeliveryHome({this.landingPage = 'available'});
  @override
  _DeliveryHomeState createState() => _DeliveryHomeState();
}

String locationString;
String addressDriver;
String latitudeDriver;
String longitudeDriver;

class _DeliveryHomeState extends State<DeliveryHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _online = true;
  Position position;
  String address;

  List<Tab> tabs = <Tab>[
    Tab(text: "  قائمة الطلبات  "),
    Tab(text: " الطلبات الجارية "),
  ];
  getCurrentPosition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var address = await Geocoder.local
        .findAddressesFromCoordinates(
            new Coordinates(position.latitude, position.longitude))
        .then((value) => locationString = value.first.addressLine);
    // setState(() {
    //   locationString = address.first.addressLine;
    // });
    print("my Location Long :${position.longitude}");
    print("my Location lat :${position.latitude}");
    print("my Location Address : $locationString");
    // sendLocation();
  }

  // sendLocation() async {
  //   try {
  //     final bool updated = await HomeRepo().sendMyCurrentLocation(
  //         lat: position.latitude, lang: position.longitude);
  //     if (updated) {
  //       print("updated");
  //     } else {
  //       print("not updated");
  //     }
  //   } catch (e) {} finally {}
  // }

  updatePosition() async {
    var value = await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MapsPikerPage()));
    print("back value is $value");
    setState(() {
      if (value != null) {
        position =
            Position(latitude: value.latitude, longitude: value.longitude);
        print("New position is $position");
        // sendLocation();
      } else {
        getCurrentPosition();
      }
    });
    await Geocoder.local
        .findAddressesFromCoordinates(
            new Coordinates(position.latitude, position.longitude))
        .then((value) => locationString = value.first.addressLine);
  }

  initialize() async {
    String isOnline = await readData(key: 'online');
    if (isOnline == null) {
      setState(() {
        _online = true;
      });
    } else if (isOnline == 'true') {
      setState(() {
        _online = true;
      });
    } else {
      setState(() {
        _online = false;
      });
    }
    await getCurrentPosition();
    setState(() {
      addressDriver = locationString;
      longitudeDriver = position.longitude.toString();
      latitudeDriver = position.latitude.toString();
    });
    // await driverallordersApi(context: context);
  }

  @override
  void initState() {
    super.initState();
    availableOrderList.clear();
    widget.landingPage == 'available'
        ? tabs = tabs
        : tabs = tabs.reversed.toList();
    initialize();
    _tabController = TabController(vsync: this, length: tabs.length);
    // HomeRepo().getOnlineStatus().then((value) {
    //   print('online status is $value');
    //   setState(() {
    //     _online = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {},
      child: SafeArea(
        child: isLoggingOut
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    backgroundColor: AppColors.darkGrey,
                  ),
                ),
              )
            : Scaffold(
                persistentFooterButtons: <Widget>[
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: MergeSemantics(
                              child: Container(
                                color: AppColors.blueGrey,
                                width: width,
                                child: ListTile(
                                  title: _online == true
                                      ? Text('متصل')
                                      : Text('غير متصل'),
                                  trailing: CupertinoSwitch(
                                    activeColor: AppColors.primaryColor,
                                    value: _online,
                                    onChanged: (bool value) async {
                                      try {
                                        // await HomeRepo()
                                        //     .toggleNotifications(status: value);
                                        setState(() {
                                          _online = value;
                                        });
                                        saveData(
                                            key: 'online',
                                            saved: _online.toString());
                                      } catch (e) {
                                        ShowToast.showToast(
                                            context, e.toString());
                                      } finally {}
                                    },
                                  ),
                                ),
                              ),
                            ))),
                  ],
                appBar: AppBar(
                  backgroundColor: AppColors.blueGrey,
                  iconTheme: IconThemeData(color: Colors.white, size: 10),
                  title: InkWell(
                    onTap: () => updatePosition(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('مكانى الحالى ',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "GE_SS_Two",
                                fontWeight: FontWeight.w900,
                                color: Colors.white)),
                        SvgPicture.asset(
                          "assets/images/map_pin.svg",
                          color: Colors.white,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: AppColors.lightFont,
                    labelColor: AppColors.primaryColor,
                    // indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BubbleTabIndicator(
                      // padding: EdgeInsets.all(30),
                      indicatorHeight: 25.0,
                      indicatorColor: Colors.transparent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: tabs,
                    controller: _tabController,
                  ),
                ),
                endDrawer: CustomSideDrawer(),
                body: _online
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          widget.landingPage == 'available'
                              ? AvailableOrders()
                              : AcceptedOrders(),
                          widget.landingPage == 'available'
                              ? AcceptedOrders()
                              : AvailableOrders(),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("assets/images/orderPlaceHolder.png"),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "لا يوجد لديك طلبات بعد\n",
                                  children: [],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "GE_SS_Two",
                                      height: 2)),
                            )
                          ],
                        ),
                      )),
      ),
    );
  }
}
