import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/services/delivery%20apis/allorders.dart';
import 'package:Mazaj/widgets/items/order_card.dart';
import 'package:flutter/material.dart';
import 'package:Mazaj/constants/globals.dart' as globals;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AvailableOrders extends StatefulWidget {
  @override
  _AvailableOrdersState createState() => _AvailableOrdersState();
}

List<Data> availableOrderList = [];

class _AvailableOrdersState extends State<AvailableOrders> {
  String errMsg;
  Position position;
  String locationString;
  bool isLoading = false;
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

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  Widget buildErr() {
    return Center(
        child: Text(
      errMsg,
      style: TextStyle(fontSize: 18),
    ));
  }

  Widget buildData() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // _loadData();
          print('reached end');
          setState(() {
            startLoading();
            driverallordersApi(
              context: context,
              status: 'new',
              paginate: true,
            );
            stopLoading();
          });
        }
      },
      child: ListView.builder(
        itemCount: availableOrderList.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderCard(
            index: index,
            // mylatitude: position.latitude.toString(),
            // mylongitude: position.longitude.toString(),
            order: availableOrderList[index],
            refreshOrers: refreshDate,
            startLoading: startLoading,
            stopLoading: stopLoading,
          );
        },
      ),
    );
  }

  Widget buildNoData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              style:
                  TextStyle(fontSize: 18, fontFamily: "GE_SS_Two", height: 2)),
        )
      ],
    );
  }

  Widget buildLoading() {
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      backgroundColor: AppColors.darkGrey,
    ));
  }

  @override
  void initState() {
    print('init of available orders');
    // print('ssssss'+nextPageUrl);
    availableOrderList.clear();
    refreshDate();
    driverallordersApi(
      context: context,
      status: 'new',
      paginate: false,
      // pagination: nextPageUrl,
    );
    // print(availableOrderList);
    super.initState();
  }

  void refreshDate() async {
    await getCurrentPosition();
    availableOrderList.clear();
    try {
      setState(() {
        isLoading = true;
      });
      print('enter');
      await driverallordersApi(
        context: context,
        status: 'new',
        paginate: false,
        // pagination: nextPageUrl,
      );
      print('exit');
      // print(availableOrderList);
    } catch (e) {
      errMsg = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    Widget child;

    if (errMsg != null) {
      child = buildErr();
    } else if (isLoading) {
      child = buildLoading();
    } else if (availableOrderList.isEmpty) {
      child = buildNoData();
    } else {
      child = globals.alreadyHaveOrder ? buildNoData() : buildData();
    }
    return Scaffold(
      body: FutureBuilder(
        builder: (_, snapshot) {
          return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(),
              scrollDirection: Axis.vertical,
              onRefresh: () {
                refreshDate();
                // if failed,use refreshFailed()
                _refreshController.refreshCompleted();
              },
              child: child);
        },
      ),
    );
  }
}
