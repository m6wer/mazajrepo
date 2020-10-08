import 'dart:async';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/services/action_call.dart';
import 'package:platform/platform.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:Mazaj/Theme/map_style.dart';
import 'package:Mazaj/main.dart';
import 'package:Mazaj/model/ordermodel.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/screens/orderDetails_page.dart';
import 'package:Mazaj/services/delivery%20apis/updatestatusprice.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:permission/permission.dart';
import 'package:Mazaj/Theme/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:Mazaj/constants/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

var geolocator = Geolocator();
var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
bool orderCollected = false;

StreamSubscription<Position> positionStream =
    geolocator.getPositionStream(locationOptions).listen((Position position) {
  print(position == null
      ? 'Unknown'
      : position.latitude.toString() + ', ' + position.longitude.toString());
});

class MapsPage extends StatefulWidget {
  final Data order;
  const MapsPage({this.order});
  @override
  _MapsPageState createState() {
    return _MapsPageState();
  }
}

bool showChatStack = false;
bool isFinishing = false;

class _MapsPageState extends State<MapsPage> {
  bool chosenCash = false;
  bool clientOrShop = true;
  BitmapDescriptor pinLocationIcon;
  loc.Location location;
  BitmapDescriptor pinDestinationIcon;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Marker> markers = {};
  // String locationString = "";
  bool isGettingLocation = false;
  bool updateLocationApi = false;
  bool findingDelivery = true;

  Position position;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints;
  LatLng selectedPosition;
  String _placeDistance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static Future<void> openMap(
      {double clientLatitude,
      double clientLongitude,
      double driverLatitude,
      double driverLongitude}) async {
    String googleUrl =
        'https://www.google.com/maps/dir/$driverLatitude,$driverLongitude/$clientLatitude,$clientLongitude';
    print(googleUrl);
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void setCustomMapPin({bool client = true}) async {
    //delivery icon
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(deliveryUserInfo.imagePath);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
      markerImageBytes,
      targetWidth: 125,
      targetHeight: 125,
    );
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();
    pinLocationIcon = BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
    //client and place
    String image = '';
    // if (client == false) {
    //   setState(() {
    //     // image = widget.order.image;
    //   });
    // } else {
    //   setState(() {
    //     // image = globals.mainUrl + widget.order.user.imagePath;
    //   });
    // }
    final File markerImageFile1 =
        await DefaultCacheManager().getSingleFile(image);
    final Uint8List markerImageBytes1 = await markerImageFile1.readAsBytes();
    final ui.Codec markerImageCodec1 = await ui.instantiateImageCodec(
      markerImageBytes1,
      targetWidth: 125,
      targetHeight: 125,
    );
    final ui.FrameInfo frameInfo1 = await markerImageCodec1.getNextFrame();
    final ByteData byteData1 = await frameInfo1.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes1 = byteData1.buffer.asUint8List();
    pinDestinationIcon = BitmapDescriptor.fromBytes(resizedMarkerImageBytes1);
  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      controller.setMapStyle(MapStyle.mapStyles);
    });
  }

  getDistination({bool client = true}) async {
    if (client) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("your position is $position");
      markers.add(Marker(
        markerId: MarkerId(
            '${(Position(latitude: double.parse(widget.order.latitude), longitude: double.parse(widget.order.longitude)))}'),
        position: LatLng(
          double.parse(widget.order.latitude),
          double.parse(widget.order.longitude),
        ),
        infoWindow: InfoWindow(
          title: ' ${widget.order.name}',
        ),
        icon: pinLocationIcon,
      ));
    } else {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("your position is $position");
      markers.add(Marker(
        markerId: MarkerId(
            '${(Position(latitude: 24.77802848815918, longitude: 46.6890068))}'),
        position: LatLng(
          24.77802848815918,
          46.6890068,
        ),
        infoWindow: InfoWindow(
          title: 'Mazaj',
          // snippet: widget.order.place.vicinity,
        ),
        icon: pinLocationIcon,
      ));
    }
    // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: new LatLng(position.latitude, position.longitude), zoom: 12)));
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {}

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(bool client) async {
    PolylinePoints polylinePoints;

    List<LatLng> polylineCoordinates = [];

    try {
      if (position != null && widget.order.name != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = Position(
            latitude: position.latitude, longitude: position.longitude);

        Position destinationCoordinates = Position(
            latitude: double.parse(widget.order.latitude),
            longitude: double.parse(widget.order.longitude));

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            // snippet: _startAddress,
          ),
          icon: pinLocationIcon,
        );
        markers.add(startMarker);
        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            double.parse(widget.order.latitude),
            double.parse(widget.order.longitude),
          ),
          infoWindow: InfoWindow(
            title: ' ${widget.order.name}',
          ),
          icon: pinDestinationIcon,
        );

        // Adding the markers to the list

        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            boundsFromLatLngList([
              LatLng(startCoordinates.latitude, startCoordinates.longitude),
              LatLng(destinationCoordinates.latitude,
                  destinationCoordinates.longitude),
            ]),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        // await _createPolylines(startCoordinates, destinationCoordinates);
        polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyD23Hw6XKGvxz0kULcS53UegpUi1_AetTM", // Google Maps API Key
          PointLatLng(startCoordinates.latitude, startCoordinates.longitude),
          PointLatLng(destinationCoordinates.latitude,
              destinationCoordinates.longitude),
          travelMode: TravelMode.driving,
        );
        print("route drawn ${result.errorMessage}");
        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Color(0xFFA97301),
          points: polylineCoordinates,
          width: 3,
        );
        polylines[id] = polyline;
        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getPermission() async {
    List<PermissionName> permissionNames = [
      PermissionName.Location,
      PermissionName.Phone
    ];
    final status = await Permission.getPermissionsStatus(permissionNames);
    print("permission Status : : $status");
    if (status[0].permissionStatus != PermissionStatus.allow) {
      print("not allowed ");
      var permissions = await Permission.requestPermissions(permissionNames);
      setState(() {});
    } else if (status[1].permissionStatus != PermissionStatus.allow) {
      var permissions = await Permission.requestPermissions(permissionNames);
      setState(() {});
      print("allowed");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getPermission();
    setCustomMapPin(client: clientOrShop);
    getDistination(client: clientOrShop);
    Future.delayed(Duration(seconds: 15)).then((value) {
      _calculateDistance(clientOrShop).then((isCalculated) {
        if (isCalculated) {
          setState(() {
            findingDelivery = false;
          });
          // ShowToast.showToast(context, "تم تحديد الطريق",
          //     backgroundColor: Color(0xFF2C6500),
          //     duration: 3,
          //     gravity: 1,
          //     textColor: Colors.white);
        } else {
          // _scaffoldKey.currentState.showSnackBar(
          //   SnackBar(
          //     content: Text('Error Calculating Distance'),
          //   ),
          // );
          setState(() {
            findingDelivery = false;
          });
        }
      });
    });
    // location = new loc.Location();
    // location.onLocationChanged.listen((loc.LocationData cLoc) {
    //   markers.clear();
    //   // getPermission();
    //   setCustomMapPin(client: clientOrShop);
    //   // driverUpdateLocationApi(
    //   //     context: context,
    //   //     order: widget.order,
    //   //     longitude_driver: position.longitude.toString(),
    //   //     latitude_driver: position.latitude.toString());
    //   getDistination(client: clientOrShop);
    //   _calculateDistance(clientOrShop);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String token;
    return WillPopScope(
      onWillPop: () {
        setState(() {
          if (showChatStack) {
            showChatStack = false;
          } else {
            showChatStack = false;
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => OrderDetailsPage(
            //               order: widget.order,
            //             )));
          }
        });
      },
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: AppColors.mainGreyColor,
                  iconTheme: IconThemeData(color: Colors.white, size: 10),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(
                                  order: widget.order,
                                ))),
                  ),
                  title: Text("تفاصيل الطلب",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  centerTitle: true,
                ),
                // endDrawer: CustomSideDrawer(),
                body: Container(
                    color: Colors.black,
                    // height: double.maxFinite,
                    width: width,
                    child:
                        // findingDelivery
                        //     ? Center(
                        //         child: Text(
                        //           '.... يرجى الإنتظار',
                        //           style: TextStyle(fontSize: 20),
                        //         ),
                        //       )
                        //     :
                        SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            color: AppColors.ligthGrey.withOpacity(0.09),
                            height: 45,
                            width: width,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                "العميل",
                                style: TextStyle(height: 2.5),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Container(
                              height: height * 0.12,
                              // color: Colors.yellow,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            '${widget.order.name}',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: "Arial",
                                              color: AppColors.ligthGrey,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            ' المملكة العربية السعودية',
                                            style: TextStyle(
                                                color: AppColors.lightFont,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 3),
                                      // ConstrainedBox(
                                      //   constraints: BoxConstraints.tight(
                                      //       Size(width * 0.3,
                                      //           height * 0.15)),
                                      //   child: Stack(
                                      //     alignment:
                                      //         AlignmentDirectional.center,
                                      //     children: <Widget>[
                                      //       Positioned(
                                      //         top: 10.0,
                                      //         child: CircleAvatar(
                                      //           radius: 30,
                                      //           backgroundImage:
                                      //               NetworkImage(
                                      //                   deliveryUserInfo
                                      //                       .imagePath,
                                      //                   scale: 1.5),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )),
                          Container(
                            color: AppColors.ligthGrey.withOpacity(0.09),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "العنوان",
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            height: 50,
                            width: width,
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.08, vertical: 10),
                              height: height * 0.15,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                              style: TextStyle(
                                                  color: AppColors.greyText))
                                        ]),
                                  ),
                                  Divider(
                                    color: AppColors.greyText,
                                    thickness: 2,
                                    height: 2,
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
                                              style: TextStyle(
                                                  color: AppColors.greyText))
                                        ]),
                                  ),
                                ],
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
                                        color:
                                            Color(0xFFEAE805).withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      widget.order.products.map((product) {
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
                                                          fontFamily:
                                                              "GE_SS_Two"),
                                                      text: "كمية   ",
                                                      children: [
                                                        TextSpan(
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Arial"),
                                                            text:
                                                                "${product.pivot.quantity}")
                                                      ]),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  "${product.name}",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  style: TextStyle(
                                                      fontFamily: "GE_SS_Two"),
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
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          // todo dilvery price
                                          widget.order.typePayment == 'cash'
                                              ? 'استلم من العميل كاش'
                                              : widget.order.typePayment ==
                                                      'network'
                                                  ? 'استلم من العميل عبر الشبكة'
                                                  : "تم الدفع مسبقاً",
                                          style: TextStyle(
                                              fontFamily: "GE_SS_Two"),
                                        ),
                                        Text("طريقة الدفع"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          // todo dilvery price
                                          widget.order.driverPrice.toString() ==
                                                  'null'
                                              ? '0 SAR'
                                              : widget.order.driverPrice
                                                      .toString() +
                                                  " " +
                                                  "SAR",
                                          style:
                                              TextStyle(fontFamily: "Roboto"),
                                        ),
                                        Text("قيمة التوصيل"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          // todo dilvery price
                                          widget.order.totalPrice.toString() +
                                              " " +
                                              "SAR",
                                          style:
                                              TextStyle(fontFamily: "Roboto"),
                                        ),
                                        Text("قيمة المشتريات"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          // todo dilvery price
                                          (double.parse(widget.order.driverPrice
                                                                  .toString() ==
                                                              'null'
                                                          ? '0'
                                                          : widget
                                                              .order.driverPrice
                                                              .toString()) +
                                                      double.parse(widget
                                                          .order.totalPrice
                                                          .toString()))
                                                  .toString() +
                                              " " +
                                              "SAR",
                                          style:
                                              TextStyle(fontFamily: "Roboto"),
                                        ),
                                        Text("اجمالي الطلب"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //go to shop
                                    markers.clear();
                                    clientOrShop = false;
                                    setCustomMapPin(client: clientOrShop);
                                    openMap(
                                      clientLatitude: 24.7780285,
                                      clientLongitude: 46.6890068,
                                      driverLatitude:
                                          double.parse(latitudeDriver),
                                      driverLongitude:
                                          double.parse(longitudeDriver),
                                    );
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  width: width * 0.4,
                                  // margin: EdgeInsets.all(100.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF101010),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          bottomLeft: Radius.circular(25.0))),
                                  child: Center(
                                    child: Text("توجه الي المتجر"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    //go to client
                                    setState(() {
                                      markers.clear();
                                      clientOrShop = true;
                                      setCustomMapPin(client: clientOrShop);
                                      openMap(
                                        clientLatitude:
                                            double.parse(widget.order.latitude),
                                        clientLongitude: double.parse(
                                            widget.order.longitude),
                                        driverLatitude:
                                            double.parse(latitudeDriver),
                                        driverLongitude:
                                            double.parse(longitudeDriver),
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: 60,
                                    width: width * 0.4,
                                    // margin: EdgeInsets.all(100.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF101010),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25.0),
                                            bottomRight:
                                                Radius.circular(25.0))),
                                    child: Center(
                                      child: Text("توجه الي العميل"),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       showChatStack = true;
                                //     });
                                //   },
                                //   child: Container(
                                //     height: 60,
                                //     width: width * 0.4,
                                //     // margin: EdgeInsets.all(100.0),
                                //     decoration: BoxDecoration(
                                //         color: Color(0xFF101010),
                                //         shape: BoxShape.rectangle,
                                //         borderRadius: BorderRadius.only(
                                //             topLeft:
                                //                 Radius.circular(25.0),
                                //             bottomLeft:
                                //                 Radius.circular(25.0))),
                                //     child: Center(
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: <Widget>[
                                //           Text("تواصل"),
                                //           SizedBox(
                                //             width: 8,
                                //           ),
                                //           SvgPicture.asset(
                                //             "assets/images/chat.svg",
                                //             color: Color(0xFFEAE805),
                                //             height: 15,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 2,
                                // ),
                                // GestureDetector(
                                //     onTap: () async {
                                //       Call.phone(
                                //           "${widget.order.user.phone}");
                                //     },
                                //     child: Container(
                                //       height: 60,
                                //       width: width * 0.4,
                                //       // margin: EdgeInsets.all(100.0),
                                //       decoration: BoxDecoration(
                                //           color: Color(0xFF101010),
                                //           shape: BoxShape.rectangle,
                                //           borderRadius:
                                //               BorderRadius.only(
                                //                   topRight:
                                //                       Radius.circular(
                                //                           25.0),
                                //                   bottomRight:
                                //                       Radius.circular(
                                //                           25.0))),
                                //       child: Center(
                                //         child:
                                //  Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment
                                //                     .center,
                                //             children: <Widget>[
                                //               Text("اتصل"),
                                //               SizedBox(
                                //                 width: 16,
                                //               ),
                                //               SvgPicture.asset(
                                //                 "assets/images/phone.svg",
                                //                 color:
                                //                     Color(0xFF1AFF00),
                                //                 height: 15,
                                //               ),
                                //             ]),
                                //       ),
                                //     )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    if (LocalPlatform().isAndroid) {
                                      final AndroidIntent intent = AndroidIntent(
                                          action: 'action_view',
                                          data: Uri.encodeFull(
                                              'https://api.whatsapp.com/send?phone=+966${widget.order.phone}'),
                                          package: 'com.whatsapp');
                                      intent.launch();
                                    } else {
                                      String url =
                                          "https://api.whatsapp.com/send?phone=+966${widget.order.phone}";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: width * 0.4,
                                    // margin: EdgeInsets.all(100.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF101010),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            bottomLeft: Radius.circular(25.0))),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("تواصل"),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Image.asset(
                                            "assets/images/whatsapp.png",
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      Call.phone("+966${widget.order.phone}");
                                    },
                                    child: Container(
                                      height: 60,
                                      width: width * 0.4,
                                      // margin: EdgeInsets.all(100.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF101010),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(25.0),
                                              bottomRight:
                                                  Radius.circular(25.0))),
                                      child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text("اتصل"),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              SvgPicture.asset(
                                                "assets/images/phone.svg",
                                                color: Color(0xFF1AFF00),
                                                height: 15,
                                              ),
                                            ]),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () async {
                          //     Call.phone("${widget.order.phone}");
                          //   },
                          //   child: Container(
                          //       height: 60,
                          //       width: width * 0.8,
                          //       // margin: EdgeInsets.all(100.0),
                          //       decoration: BoxDecoration(
                          //           color: Color(0xFF101010),
                          //           shape: BoxShape.rectangle,
                          //           borderRadius: BorderRadius.all(
                          //               Radius.circular(25.0))),
                          //       child: Center(
                          //         child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Text("اتصل"),
                          //               SizedBox(
                          //                 width: 16,
                          //               ),
                          //               SvgPicture.asset(
                          //                 "assets/images/phone.svg",
                          //                 color: Color(0xFF1AFF00),
                          //                 height: 15,
                          //               ),
                          //             ]),
                          //       )),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isFinishing = true;
                                });
                                //end order
                                // Call.phone("${widget.order.client.mobile}");
                                if (widget.order.typePayment != 'paylink') {
                                  await Alert(
                                      context: context,
                                      title: "تم انهاء الطلب",
                                      style: AlertStyle(
                                        titleStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      content: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                  'برجاء اختيار طريقة دفع الفاتورة',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: DialogButton(
                                                  color: Color(0xFF3E4243),
                                                  onPressed: () async {
                                                    setState(() {
                                                      chosenCash = true;
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text(
                                                    "كاش",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: DialogButton(
                                                  color: Color(0xFF3E4243),
                                                  onPressed: () async {
                                                    chosenCash = false;
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      isFinishing = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    "شبكة",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      buttons: []).show();
                                  if (chosenCash) {
                                    // String receiptPayment = '';
                                    // TextEditingController receiptCost =
                                    //     TextEditingController();
                                    print('in');
                                    if (widget.order.status ==
                                        'delivery_by_representative') {
                                      // await Alert(
                                      //     context: context,
                                      //     title: "تم انهاء الطلب",
                                      //     style: AlertStyle(
                                      //       titleStyle: TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 14,
                                      //       ),
                                      //     ),
                                      //     content: Container(
                                      //       width: double.infinity,
                                      //       color: Colors.white,
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.all(12.0),
                                      //         child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.stretch,
                                      //           children: <Widget>[
                                      //             Padding(
                                      //               padding: const EdgeInsets
                                      //                   .symmetric(vertical: 8.0),
                                      //               child: Text(
                                      //                 'برجاء ادخال قيمة الفاتورة المصدرة',
                                      //                 style: TextStyle(
                                      //                   color: Colors.black,
                                      //                   fontSize: 14,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets
                                      //                   .symmetric(vertical: 8.0),
                                      //               child: Container(
                                      //                 decoration: BoxDecoration(
                                      //                     border: Border.all(
                                      //                         color: Color(
                                      //                             0xFF707070)),
                                      //                     color: Colors.white),
                                      //                 child: Padding(
                                      //                   padding:
                                      //                       const EdgeInsets.all(
                                      //                           8.0),
                                      //                   child: Column(
                                      //                     crossAxisAlignment:
                                      //                         CrossAxisAlignment
                                      //                             .center,
                                      //                     children: [
                                      //                       Text(
                                      //                         'التكلفة',
                                      //                         style: TextStyle(
                                      //                           color:
                                      //                               Colors.black,
                                      //                           fontSize: 14,
                                      //                         ),
                                      //                       ),
                                      //                       TextFormField(
                                      //                         enabled: true,
                                      //                         controller:
                                      //                             receiptCost,
                                      //                         textAlign: TextAlign
                                      //                             .center,
                                      //                         keyboardType:
                                      //                             TextInputType
                                      //                                 .number,
                                      //                         cursorColor: Color(
                                      //                             0xFF2C3137),
                                      //                         onChanged: (value) {
                                      //                           receiptPayment =
                                      //                               value;
                                      //                         },
                                      //                         style: TextStyle(
                                      //                             color: Color(
                                      //                                 0xFF2C3137),
                                      //                             fontSize: 43,
                                      //                             fontFamily:
                                      //                                 'LATOREGULAR'),
                                      //                         decoration:
                                      //                             InputDecoration(
                                      //                           fillColor: Color(
                                      //                               0xFF2C3137),
                                      //                           hintText: '00.00',
                                      //                           hintStyle:
                                      //                               TextStyle(
                                      //                             color: Color(
                                      //                                 0xFF2C3137),
                                      //                             fontSize: 43.0,
                                      //                           ),
                                      //                           enabledBorder:
                                      //                               UnderlineInputBorder(
                                      //                             borderSide: BorderSide(
                                      //                                 color: Color(
                                      //                                     0xFF2C3137)),
                                      //                           ),
                                      //                           focusedBorder:
                                      //                               UnderlineInputBorder(
                                      //                             borderSide: BorderSide(
                                      //                                 color: Color(
                                      //                                     0xFF2C3137)),
                                      //                           ),
                                      //                           border: UnderlineInputBorder(
                                      //                               borderRadius:
                                      //                                   BorderRadius.all(
                                      //                                       Radius.circular(
                                      //                                           1)),
                                      //                               borderSide:
                                      //                                   BorderSide(
                                      //                                       color:
                                      //                                           Color(0xFF2C3137))),
                                      //                         ),
                                      //                       ),
                                      //                       Text(
                                      //                         'R . S',
                                      //                         style: TextStyle(
                                      //                           color:
                                      //                               Colors.black,
                                      //                           fontSize: 14,
                                      //                         ),
                                      //                       ),
                                      //                       Text(
                                      //                         ' R . S استلم من العميل ${widget.order.driverPrice}  ثمن التوصيل',
                                      //                         style: TextStyle(
                                      //                           color:
                                      //                               Colors.black,
                                      //                           fontSize: 12,
                                      //                         ),
                                      //                       ),
                                      //                       // double.parse(widget.order.driverPrice) -
                                      //                       //             double.parse(widget.order.clientPrice) >
                                      //                       //         0
                                      //                       //     ? Text(
                                      //                       //         ' R . S و سيتم تحويل ${(double.parse(widget.order.driverPrice) - double.parse(widget.order.clientPrice)).toString()} الي محفظتك',
                                      //                       //         style:
                                      //                       //             TextStyle(
                                      //                       //           color:
                                      //                       //               Colors.black,
                                      //                       //           fontSize:
                                      //                       //               12,
                                      //                       //         ),
                                      //                       //       )
                                      //                       //     : Container()
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding: const EdgeInsets
                                      //                   .symmetric(vertical: 8.0),
                                      //               child: DialogButton(
                                      //                 color: Color(0xFF3E4243),
                                      //                 onPressed: () async {
                                      //                   if (double.parse(
                                      //                           receiptPayment
                                      //                               .trim()
                                      //                               .toString()) >
                                      //                       0) {
                                      //                     widget.order
                                      //                             .totalPrice =
                                      //                         receiptPayment;

                                      //                     receiptCost.clear();
                                      //                     receiptPayment = '';
                                      //                     Navigator.pop(context);
                                      //                   }
                                      //                 },
                                      //                 child: Text(
                                      //                   "اصدر الفاتورة",
                                      //                   style: TextStyle(
                                      //                       color: Colors.white,
                                      //                       fontSize: 16),
                                      //                 ),
                                      //               ),
                                      //             )
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     buttons: []).show();
                                    }
                                    //put cash api here
                                    await driverUpdateOrderStatusPriceApi(
                                      typePayment: 'cash',
                                      order: widget.order,
                                      context: context,
                                    );
                                    print('out');
                                  } else {
                                    //put network api here
                                    await driverUpdateOrderStatusPriceApi(
                                      typePayment: 'network',
                                      order: widget.order,
                                      context: context,
                                    );
                                  }
                                } else {
                                  //put if already paid api here
                                  await driverUpdateOrderStatusPriceApi(
                                    typePayment: widget.order.typePayment,
                                    order: widget.order,
                                    context: context,
                                  );
                                }
                              },
                              child: Container(
                                  height: 60,
                                  width: width * 0.8,
                                  // margin: EdgeInsets.all(100.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF101010),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  child: Center(
                                    child: isFinishing
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.primaryColor),
                                              backgroundColor:
                                                  AppColors.darkGrey,
                                            ),
                                          )
                                        : Text(
                                            'الانتهاء من الطلب',
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                  )))
                        ],
                      ),
                    ))
                //       SlidingSheet(
                //   elevation: 8,
                //   cornerRadius: 16,
                //   snapSpec: const SnapSpec(
                //     // Enable snapping. This is true by default.
                //     snap: false,
                //     // Set custom snapping points.
                //     snappings: [0.09, 0.5, 1.0],
                //     // Define to what the snappings relate to. In this case,
                //     // the total available space that the sheet can expand to.
                //     positioning: SnapPositioning.relativeToAvailableSpace,
                //   ),
                //   // The body widget will be displayed under the SlidingSheet
                //   // and a parallax effect can be applied to it.
                //   body: Stack(
                //     children: <Widget>[
                //       // Positioned(
                //       //   top: 0,
                //       //   left: 0,
                //       //   right: 0,
                //       //   bottom: 0,
                //       //   child: Container(
                //       //     child: GoogleMap(
                //       //       // myLocationButtonEnabled: true,
                //       //       // trafficEnabled: true,
                //       //       mapType: MapType.normal,
                //       //       initialCameraPosition: CameraPosition(
                //       //         target: LatLng(23.8859, 45.0792),
                //       //         zoom: 12,
                //       //       ),
                //       //       polylines: Set<Polyline>.of(polylines.values),
                //       //       onMapCreated: _onMapCreated,

                //       //       compassEnabled: true,
                //       //       zoomControlsEnabled: false,
                //       //       scrollGesturesEnabled: true,
                //       //       markers: markers != null
                //       //           ? Set<Marker>.from(markers)
                //       //           : null,
                //       //     ),
                //       //     width: MediaQuery.of(context).size.width,
                //       //     height: MediaQuery.of(context).size.height,
                //       //   ),
                //       // ),
                //       // Positioned(
                //       //   bottom: height * 0.2,
                //       //   right: width * 0.1,
                //       //   left: width * 0.1,
                //       //   child: findingDelivery
                //       //       ? Container(
                //       //           color: Colors.black.withOpacity(0.7),
                //       //           height: 60,
                //       //           child: Stack(
                //       //             children: <Widget>[
                //       //               Center(
                //       //                   child: Row(
                //       //                 crossAxisAlignment:
                //       //                     CrossAxisAlignment.start,
                //       //                 mainAxisAlignment: MainAxisAlignment.center,
                //       //                 children: <Widget>[
                //       //                   Icon(Icons.drive_eta),
                //       //                   SizedBox(
                //       //                     width: 10,
                //       //                   ),
                //       //                   Text("جارى البحث عن أفضل طريق"),
                //       //                 ],
                //       //               )),
                //       //               Align(
                //       //                 alignment: Alignment.bottomCenter,
                //       //                 child: SizedBox(
                //       //                     height: 3,
                //       //                     child: LinearProgressIndicator(
                //       //                       valueColor:
                //       //                           AlwaysStoppedAnimation<Color>(
                //       //                               AppColors.mainGreyColor),
                //       //                       backgroundColor:
                //       //                           AppColors.primaryColor,
                //       //                     )),
                //       //               )
                //       //             ],
                //       //           ),
                //       //         )
                //       //       : Container(),
                //       // ),
                //       // Positioned(
                //       //   top: 16,
                //       //   right: 16,
                //       //   left: 16,
                //       //   child: ClipRRect(
                //       //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //       //     child: Container(
                //       //       padding: EdgeInsets.all(10),
                //       //       constraints: BoxConstraints(
                //       //           minHeight:
                //       //               MediaQuery.of(context).size.width / 10),
                //       //       width: MediaQuery.of(context).size.width * 0.9,
                //       //       color: Color(0x44000000),
                //       //       child: Column(
                //       //         children: <Widget>[
                //       //           Container(
                //       //             child: Row(
                //       //               mainAxisAlignment:
                //       //                   MainAxisAlignment.spaceAround,
                //       //               children: <Widget>[
                //       //                 Icon(
                //       //                   Icons.location_on,
                //       //                   color: AppColors.primaryColor,
                //       //                 ),
                //       //                 Container(
                //       //                     width: width * 0.7,
                //       //                     child: Text(
                //       //                       "${widget.order.name}",
                //       //                       textAlign: TextAlign.center,
                //       //                       style: TextStyle(fontFamily: "Arial"),
                //       //                     )),
                //       //               ],
                //       //             ),
                //       //           ),
                //       //           Divider(
                //       //             thickness: 0.5,
                //       //             color: Colors.grey[500],
                //       //           ),
                //       //           Row(
                //       //             mainAxisAlignment:
                //       //                 MainAxisAlignment.spaceBetween,
                //       //             mainAxisSize: MainAxisSize.min,
                //       //             children: <Widget>[
                //       //               Padding(
                //       //                   padding:
                //       //                       EdgeInsets.symmetric(horizontal: 20),
                //       //                   child: Row(
                //       //                     children: <Widget>[
                //       //                       Image.asset(
                //       //                           "assets/images/delivery_icon.png"),
                //       //                       SizedBox(
                //       //                         width: 10,
                //       //                       ),
                //       //                       Text(
                //       //                         "${widget.order.driverPrice} SAR",
                //       //                         style:
                //       //                             TextStyle(fontFamily: "Arial"),
                //       //                       ),
                //       //                     ],
                //       //                   )),
                //       //               SizedBox(
                //       //                 width: 1,
                //       //                 height: 30,
                //       //                 child: Container(
                //       //                   color: Colors.grey[500],
                //       //                 ),
                //       //               ),
                //       //               Padding(
                //       //                   padding:
                //       //                       EdgeInsets.symmetric(horizontal: 20),
                //       //                   child: Text("$_placeDistance Km",
                //       //                       style:
                //       //                           TextStyle(fontFamily: "Arial"))),
                //       //             ],
                //       //           )
                //       //         ],
                //       //       ),
                //       //     ),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                //   builder: (context, state) {
                //     // This is the content of the sheet that will get
                //     // scrolled, if the content is bigger than the available
                //     // height of the sheet.
                //     return Container(
                //       color: Colors.black,
                //       // height: double.maxFinite,
                //       width: width,
                //       child:
                //           // findingDelivery
                //           //     ? Center(
                //           //         child: Text(
                //           //           '.... يرجى الإنتظار',
                //           //           style: TextStyle(fontSize: 20),
                //           //         ),
                //           //       )
                //           //     :
                //           SingleChildScrollView(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           mainAxisSize: MainAxisSize.max,
                //           children: <Widget>[
                //             Container(
                //               color: AppColors.ligthGrey.withOpacity(0.09),
                //               height: 45,
                //               width: width,
                //               child: Padding(
                //                 padding: EdgeInsets.symmetric(horizontal: 45),
                //                 child: Text(
                //                   "العميل",
                //                   style: TextStyle(height: 2.5),
                //                   textAlign: TextAlign.right,
                //                 ),
                //               ),
                //             ),
                //             Container(
                //                 height: height * 0.12,
                //                 // color: Colors.yellow,
                //                 child: Center(
                //                   child: Padding(
                //                     padding: EdgeInsets.symmetric(horizontal: 30),
                //                     child: Row(
                //                       mainAxisAlignment: MainAxisAlignment.end,
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.center,
                //                       children: <Widget>[
                //                         Column(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.end,
                //                           children: <Widget>[
                //                             Text(
                //                               widget.order.name,
                //                               style: TextStyle(
                //                                 fontSize: 22,
                //                                 fontFamily: "Arial",
                //                                 color: AppColors.ligthGrey,
                //                               ),
                //                             ),
                //                             SizedBox(
                //                               height: 5,
                //                             ),
                //                             Text(
                //                               ' المملكة العربية السعودية',
                //                               style: TextStyle(
                //                                   color: AppColors.lightFont,
                //                                   fontSize: 14),
                //                             ),
                //                           ],
                //                         ),
                //                         SizedBox(width: 3),
                //                         // ConstrainedBox(
                //                         //   constraints: BoxConstraints.tight(
                //                         //       Size(width * 0.3,
                //                         //           height * 0.15)),
                //                         //   child: Stack(
                //                         //     alignment:
                //                         //         AlignmentDirectional.center,
                //                         //     children: <Widget>[
                //                         //       Positioned(
                //                         //         top: 10.0,
                //                         //         child: CircleAvatar(
                //                         //           radius: 30,
                //                         //           backgroundImage:
                //                         //               NetworkImage(
                //                         //                   deliveryUserInfo
                //                         //                       .imagePath,
                //                         //                   scale: 1.5),
                //                         //         ),
                //                         //       ),
                //                         //     ],
                //                         //   ),
                //                         // ),
                //                       ],
                //                     ),
                //                   ),
                //                 )),
                //             Container(
                //               color: AppColors.ligthGrey.withOpacity(0.09),
                //               padding: EdgeInsets.symmetric(horizontal: 30),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 children: <Widget>[
                //                   Text(
                //                     "العنوان",
                //                     textAlign: TextAlign.right,
                //                   ),
                //                 ],
                //               ),
                //               height: 50,
                //               width: width,
                //             ),
                //             Container(
                //                 margin: EdgeInsets.symmetric(
                //                     horizontal: width * 0.08, vertical: 10),
                //                 height: height * 0.15,
                //                 child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceAround,
                //                   crossAxisAlignment: CrossAxisAlignment.end,
                //                   children: <Widget>[
                //                     RichText(
                //                       textAlign: TextAlign.right,
                //                       textDirection: TextDirection.rtl,
                //                       text: TextSpan(
                //                           style: TextStyle(color: Colors.white),
                //                           text: "من     ",
                //                           children: [
                //                             TextSpan(
                //                                 text: "$locationString",
                //                                 style: TextStyle(
                //                                     color: AppColors.greyText))
                //                           ]),
                //                     ),
                //                     Divider(
                //                       color: AppColors.greyText,
                //                       thickness: 2,
                //                       height: 2,
                //                     ),
                //                     RichText(
                //                       textAlign: TextAlign.right,
                //                       textDirection: TextDirection.rtl,
                //                       text: TextSpan(
                //                           style: TextStyle(color: Colors.white),
                //                           text: "إلى     ",
                //                           children: [
                //                             TextSpan(
                //                                 text: "${widget.order.address}",
                //                                 style: TextStyle(
                //                                     color: AppColors.greyText))
                //                           ]),
                //                     ),
                //                   ],
                //                 )),
                //             Container(
                //               color: AppColors.ligthGrey.withOpacity(0.09),
                //               padding: EdgeInsets.symmetric(horizontal: 30),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 children: <Widget>[
                //                   // Text(
                //                   //   " العدد ${widget.order.products.length}",
                //                   //   style: TextStyle(color: AppColors.primaryColor),
                //                   //   textAlign: TextAlign.right,
                //                   // ),
                //                   Text(
                //                     "الطلبات",
                //                     textAlign: TextAlign.right,
                //                   ),
                //                 ],
                //               ),
                //               height: 50,
                //               width: width,
                //             ),
                //             Align(
                //               alignment: Alignment.center,
                //               child: Container(
                //                   width: width * 0.9,
                //                   margin: EdgeInsets.all(10),
                //                   padding: EdgeInsets.all(10),
                //                   decoration: BoxDecoration(
                //                       border: Border.all(
                //                           color:
                //                               Color(0xFFEAE805).withOpacity(0.3)),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceBetween,
                //                     crossAxisAlignment: CrossAxisAlignment.start,
                //                     children:
                //                         widget.order.products.map((product) {
                //                       return Column(
                //                         children: [
                //                           Padding(
                //                             padding: const EdgeInsets.all(8.0),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.spaceBetween,
                //                               children: <Widget>[
                //                                 Expanded(
                //                                   flex: 1,
                //                                   child: RichText(
                //                                     text: TextSpan(
                //                                         style: TextStyle(
                //                                             fontFamily:
                //                                                 "GE_SS_Two"),
                //                                         text: "كمية   ",
                //                                         children: [
                //                                           TextSpan(
                //                                               style: TextStyle(
                //                                                   fontFamily:
                //                                                       "Arial"),
                //                                               text:
                //                                                   "${product.pivot.quantity}")
                //                                         ]),
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   flex: 3,
                //                                   child: Text(
                //                                     "${product.name}",
                //                                     textDirection:
                //                                         TextDirection.rtl,
                //                                     style: TextStyle(
                //                                         fontFamily: "GE_SS_Two"),
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Divider(
                //                             color: Colors.white.withOpacity(0.6),
                //                           ),
                //                         ],
                //                       );
                //                     }).toList(),
                //                   )),
                //             ),
                //             Container(
                //               color: AppColors.ligthGrey.withOpacity(0.09),
                //               padding: EdgeInsets.symmetric(horizontal: 30),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.end,
                //                 children: <Widget>[
                //                   Text(
                //                     "قيمة الطلب",
                //                     textAlign: TextAlign.right,
                //                   ),
                //                 ],
                //               ),
                //               height: 50,
                //               width: width,
                //             ),
                //             Container(
                //               margin: EdgeInsets.symmetric(vertical: 10),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: <Widget>[
                //                     Padding(
                //                       padding: EdgeInsets.symmetric(
                //                           horizontal: 30, vertical: 10),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: <Widget>[
                //                           Text(
                //                             // todo dilvery price
                //                             widget.order.transactionNo
                //                                         .toString() ==
                //                                     'null'
                //                                 ? 'استلم من العميل كاش'
                //                                 : "تم الدفع مسبقاً",
                //                             style: TextStyle(
                //                                 fontFamily: "GE_SS_Two"),
                //                           ),
                //                           Text("طريقة الدفع"),
                //                         ],
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 30),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: <Widget>[
                //                           Text(
                //                             // todo dilvery price
                //                             widget.order.driverPrice.toString() ==
                //                                     'null'
                //                                 ? '0 SAR'
                //                                 : widget.order.driverPrice
                //                                         .toString() +
                //                                     " " +
                //                                     "SAR",
                //                             style:
                //                                 TextStyle(fontFamily: "Roboto"),
                //                           ),
                //                           Text("قيمة التوصيل"),
                //                         ],
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: EdgeInsets.symmetric(
                //                           horizontal: 30, vertical: 20),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: <Widget>[
                //                           Text(
                //                             // todo dilvery price
                //                             widget.order.totalPrice.toString() +
                //                                 " " +
                //                                 "SAR",
                //                             style:
                //                                 TextStyle(fontFamily: "Roboto"),
                //                           ),
                //                           Text("قيمة المشتريات"),
                //                         ],
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 30),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: <Widget>[
                //                           Text(
                //                             // todo dilvery price
                //                             (double.parse(widget.order.driverPrice
                //                                                     .toString() ==
                //                                                 'null'
                //                                             ? '0'
                //                                             : widget
                //                                                 .order.driverPrice
                //                                                 .toString()) +
                //                                         double.parse(widget
                //                                             .order.totalPrice
                //                                             .toString()))
                //                                     .toString() +
                //                                 " " +
                //                                 "SAR",
                //                             style:
                //                                 TextStyle(fontFamily: "Roboto"),
                //                           ),
                //                           Text("اجمالي الطلب"),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: <Widget>[
                //                 GestureDetector(
                //                   onTap: () {
                //                     setState(() {
                //                       //go to shop
                //                       markers.clear();
                //                       clientOrShop = false;
                //                       setCustomMapPin(client: clientOrShop);
                //                       openMap(24.7780285, 46.6890068);
                //                     });
                //                   },
                //                   child: Container(
                //                     height: 60,
                //                     width: width * 0.4,
                //                     // margin: EdgeInsets.all(100.0),
                //                     decoration: BoxDecoration(
                //                         color: Color(0xFF101010),
                //                         shape: BoxShape.rectangle,
                //                         borderRadius: BorderRadius.only(
                //                             topLeft: Radius.circular(25.0),
                //                             bottomLeft: Radius.circular(25.0))),
                //                     child: Center(
                //                       child: Text("توجه الي المتجر"),
                //                     ),
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   width: 2,
                //                 ),
                //                 GestureDetector(
                //                     onTap: () async {
                //                       //go to client
                //                       setState(() {
                //                         markers.clear();
                //                         clientOrShop = true;
                //                         setCustomMapPin(client: clientOrShop);
                //                         openMap(
                //                             double.parse(widget.order.latitude),
                //                             double.parse(widget.order.longitude));
                //                       });
                //                     },
                //                     child: Container(
                //                       height: 60,
                //                       width: width * 0.4,
                //                       // margin: EdgeInsets.all(100.0),
                //                       decoration: BoxDecoration(
                //                           color: Color(0xFF101010),
                //                           shape: BoxShape.rectangle,
                //                           borderRadius: BorderRadius.only(
                //                               topRight: Radius.circular(25.0),
                //                               bottomRight:
                //                                   Radius.circular(25.0))),
                //                       child: Center(
                //                         child: Text("توجه الي العميل"),
                //                       ),
                //                     )),
                //               ],
                //             ),
                //             SizedBox(
                //               height: 10,
                //             ),
                //             // ),
                //             Padding(
                //               padding: const EdgeInsets.only(top: 9.0),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: <Widget>[
                //                   // GestureDetector(
                //                   //   onTap: () {
                //                   //     setState(() {
                //                   //       showChatStack = true;
                //                   //     });
                //                   //   },
                //                   //   child: Container(
                //                   //     height: 60,
                //                   //     width: width * 0.4,
                //                   //     // margin: EdgeInsets.all(100.0),
                //                   //     decoration: BoxDecoration(
                //                   //         color: Color(0xFF101010),
                //                   //         shape: BoxShape.rectangle,
                //                   //         borderRadius: BorderRadius.only(
                //                   //             topLeft:
                //                   //                 Radius.circular(25.0),
                //                   //             bottomLeft:
                //                   //                 Radius.circular(25.0))),
                //                   //     child: Center(
                //                   //       child: Row(
                //                   //         mainAxisAlignment:
                //                   //             MainAxisAlignment.center,
                //                   //         children: <Widget>[
                //                   //           Text("تواصل"),
                //                   //           SizedBox(
                //                   //             width: 8,
                //                   //           ),
                //                   //           SvgPicture.asset(
                //                   //             "assets/images/chat.svg",
                //                   //             color: Color(0xFFEAE805),
                //                   //             height: 15,
                //                   //           ),
                //                   //         ],
                //                   //       ),
                //                   //     ),
                //                   //   ),
                //                   // ),
                //                   // SizedBox(
                //                   //   width: 2,
                //                   // ),
                //                   // GestureDetector(
                //                   //     onTap: () async {
                //                   //       Call.phone(
                //                   //           "${widget.order.user.phone}");
                //                   //     },
                //                   //     child: Container(
                //                   //       height: 60,
                //                   //       width: width * 0.4,
                //                   //       // margin: EdgeInsets.all(100.0),
                //                   //       decoration: BoxDecoration(
                //                   //           color: Color(0xFF101010),
                //                   //           shape: BoxShape.rectangle,
                //                   //           borderRadius:
                //                   //               BorderRadius.only(
                //                   //                   topRight:
                //                   //                       Radius.circular(
                //                   //                           25.0),
                //                   //                   bottomRight:
                //                   //                       Radius.circular(
                //                   //                           25.0))),
                //                   //       child: Center(
                //                   //         child:
                //                   //  Row(
                //                   //             mainAxisAlignment:
                //                   //                 MainAxisAlignment
                //                   //                     .center,
                //                   //             children: <Widget>[
                //                   //               Text("اتصل"),
                //                   //               SizedBox(
                //                   //                 width: 16,
                //                   //               ),
                //                   //               SvgPicture.asset(
                //                   //                 "assets/images/phone.svg",
                //                   //                 color:
                //                   //                     Color(0xFF1AFF00),
                //                   //                 height: 15,
                //                   //               ),
                //                   //             ]),
                //                   //       ),
                //                   //     )),
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(top: 9.0),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: <Widget>[
                //                   GestureDetector(
                //                     onTap: () async {
                //                       if (LocalPlatform().isAndroid) {
                //                         final AndroidIntent intent = AndroidIntent(
                //                             action: 'action_view',
                //                             data: Uri.encodeFull(
                //                                 'https://api.whatsapp.com/send?phone=+966${widget.order.phone}'),
                //                             package: 'com.whatsapp');
                //                         intent.launch();
                //                       } else {
                //                         String url =
                //                             "https://api.whatsapp.com/send?phone=+966${widget.order.phone}";
                //                         if (await canLaunch(url)) {
                //                           await launch(url);
                //                         } else {
                //                           throw 'Could not launch $url';
                //                         }
                //                       }
                //                     },
                //                     child: Container(
                //                       height: 60,
                //                       width: width * 0.4,
                //                       // margin: EdgeInsets.all(100.0),
                //                       decoration: BoxDecoration(
                //                           color: Color(0xFF101010),
                //                           shape: BoxShape.rectangle,
                //                           borderRadius: BorderRadius.only(
                //                               topLeft: Radius.circular(25.0),
                //                               bottomLeft: Radius.circular(25.0))),
                //                       child: Center(
                //                         child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           children: <Widget>[
                //                             Text("تواصل"),
                //                             SizedBox(
                //                               width: 8,
                //                             ),
                //                             Image.asset(
                //                               "assets/images/whatsapp.png",
                //                               height: 15,
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     width: 2,
                //                   ),
                //                   GestureDetector(
                //                       onTap: () async {
                //                         Call.phone("+966${widget.order.phone}");
                //                       },
                //                       child: Container(
                //                         height: 60,
                //                         width: width * 0.4,
                //                         // margin: EdgeInsets.all(100.0),
                //                         decoration: BoxDecoration(
                //                             color: Color(0xFF101010),
                //                             shape: BoxShape.rectangle,
                //                             borderRadius: BorderRadius.only(
                //                                 topRight: Radius.circular(25.0),
                //                                 bottomRight:
                //                                     Radius.circular(25.0))),
                //                         child: Center(
                //                           child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: <Widget>[
                //                                 Text("اتصل"),
                //                                 SizedBox(
                //                                   width: 16,
                //                                 ),
                //                                 SvgPicture.asset(
                //                                   "assets/images/phone.svg",
                //                                   color: Color(0xFF1AFF00),
                //                                   height: 15,
                //                                 ),
                //                               ]),
                //                         ),
                //                       )),
                //                 ],
                //               ),
                //             ),
                //             // GestureDetector(
                //             //   onTap: () async {
                //             //     Call.phone("${widget.order.phone}");
                //             //   },
                //             //   child: Container(
                //             //       height: 60,
                //             //       width: width * 0.8,
                //             //       // margin: EdgeInsets.all(100.0),
                //             //       decoration: BoxDecoration(
                //             //           color: Color(0xFF101010),
                //             //           shape: BoxShape.rectangle,
                //             //           borderRadius: BorderRadius.all(
                //             //               Radius.circular(25.0))),
                //             //       child: Center(
                //             //         child: Row(
                //             //             mainAxisAlignment:
                //             //                 MainAxisAlignment.center,
                //             //             children: <Widget>[
                //             //               Text("اتصل"),
                //             //               SizedBox(
                //             //                 width: 16,
                //             //               ),
                //             //               SvgPicture.asset(
                //             //                 "assets/images/phone.svg",
                //             //                 color: Color(0xFF1AFF00),
                //             //                 height: 15,
                //             //               ),
                //             //             ]),
                //             //       )),
                //             // ),
                //             SizedBox(
                //               height: 5,
                //             ),
                //             GestureDetector(
                //                 onTap: () async {
                //                   //end order
                //                   // Call.phone("${widget.order.client.mobile}");
                //                   String receiptPayment = '';
                //                   TextEditingController receiptCost =
                //                       TextEditingController();
                //                   print('in');
                //                   if (widget.order.status == 'قيد التوصيل') {
                //                     await Alert(
                //                         context: context,
                //                         title: "تم انهاء الطلب",
                //                         style: AlertStyle(
                //                           titleStyle: TextStyle(
                //                             color: Colors.white,
                //                             fontSize: 14,
                //                           ),
                //                         ),
                //                         content: Container(
                //                           width: double.infinity,
                //                           color: Colors.white,
                //                           child: Padding(
                //                             padding: const EdgeInsets.all(12.0),
                //                             child: Column(
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.stretch,
                //                               children: <Widget>[
                //                                 Padding(
                //                                   padding:
                //                                       const EdgeInsets.symmetric(
                //                                           vertical: 8.0),
                //                                   child: Text(
                //                                     'برجاء ادخال قيمة الفاتورة المصدرة',
                //                                     style: TextStyle(
                //                                       color: Colors.black,
                //                                       fontSize: 14,
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Padding(
                //                                   padding:
                //                                       const EdgeInsets.symmetric(
                //                                           vertical: 8.0),
                //                                   child: Container(
                //                                     decoration: BoxDecoration(
                //                                         border: Border.all(
                //                                             color: Color(
                //                                                 0xFF707070)),
                //                                         color: Colors.white),
                //                                     child: Padding(
                //                                       padding:
                //                                           const EdgeInsets.all(
                //                                               8.0),
                //                                       child: Column(
                //                                         crossAxisAlignment:
                //                                             CrossAxisAlignment
                //                                                 .center,
                //                                         children: [
                //                                           Text(
                //                                             'التكلفة',
                //                                             style: TextStyle(
                //                                               color: Colors.black,
                //                                               fontSize: 14,
                //                                             ),
                //                                           ),
                //                                           TextFormField(
                //                                             enabled: true,
                //                                             controller:
                //                                                 receiptCost,
                //                                             textAlign:
                //                                                 TextAlign.center,
                //                                             keyboardType:
                //                                                 TextInputType
                //                                                     .number,
                //                                             cursorColor:
                //                                                 Color(0xFF2C3137),
                //                                             onChanged: (value) {
                //                                               receiptPayment =
                //                                                   value;
                //                                             },
                //                                             style: TextStyle(
                //                                                 color: Color(
                //                                                     0xFF2C3137),
                //                                                 fontSize: 43,
                //                                                 fontFamily:
                //                                                     'LATOREGULAR'),
                //                                             decoration:
                //                                                 InputDecoration(
                //                                               fillColor: Color(
                //                                                   0xFF2C3137),
                //                                               hintText: '00.00',
                //                                               hintStyle:
                //                                                   TextStyle(
                //                                                 color: Color(
                //                                                     0xFF2C3137),
                //                                                 fontSize: 43.0,
                //                                               ),
                //                                               enabledBorder:
                //                                                   UnderlineInputBorder(
                //                                                 borderSide: BorderSide(
                //                                                     color: Color(
                //                                                         0xFF2C3137)),
                //                                               ),
                //                                               focusedBorder:
                //                                                   UnderlineInputBorder(
                //                                                 borderSide: BorderSide(
                //                                                     color: Color(
                //                                                         0xFF2C3137)),
                //                                               ),
                //                                               border: UnderlineInputBorder(
                //                                                   borderRadius: BorderRadius
                //                                                       .all(Radius
                //                                                           .circular(
                //                                                               1)),
                //                                                   borderSide: BorderSide(
                //                                                       color: Color(
                //                                                           0xFF2C3137))),
                //                                             ),
                //                                           ),
                //                                           Text(
                //                                             'R . S',
                //                                             style: TextStyle(
                //                                               color: Colors.black,
                //                                               fontSize: 14,
                //                                             ),
                //                                           ),
                //                                           Text(
                //                                             ' R . S استلم من العميل ${widget.order.driverPrice}  ثمن التوصيل',
                //                                             style: TextStyle(
                //                                               color: Colors.black,
                //                                               fontSize: 12,
                //                                             ),
                //                                           ),
                //                                           // double.parse(widget.order.driverPrice) -
                //                                           //             double.parse(widget.order.clientPrice) >
                //                                           //         0
                //                                           //     ? Text(
                //                                           //         ' R . S و سيتم تحويل ${(double.parse(widget.order.driverPrice) - double.parse(widget.order.clientPrice)).toString()} الي محفظتك',
                //                                           //         style:
                //                                           //             TextStyle(
                //                                           //           color:
                //                                           //               Colors.black,
                //                                           //           fontSize:
                //                                           //               12,
                //                                           //         ),
                //                                           //       )
                //                                           //     : Container()
                //                                         ],
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Padding(
                //                                   padding:
                //                                       const EdgeInsets.symmetric(
                //                                           vertical: 8.0),
                //                                   child: DialogButton(
                //                                     color: Color(0xFF3E4243),
                //                                     onPressed: () async {
                //                                       if (double.parse(
                //                                               receiptPayment
                //                                                   .trim()
                //                                                   .toString()) >
                //                                           0) {
                //                                         widget.order.totalPrice =
                //                                             receiptPayment;

                //                                         receiptCost.clear();
                //                                         receiptPayment = '';
                //                                         Navigator.pop(context);
                //                                       }
                //                                     },
                //                                     child: Text(
                //                                       "اصدر الفاتورة",
                //                                       style: TextStyle(
                //                                           color: Colors.white,
                //                                           fontSize: 16),
                //                                     ),
                //                                   ),
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ),
                //                         buttons: []).show();
                //                   }
                //                   await driverUpdateOrderStatusPriceApi(
                //                     order: widget.order,
                //                     context: context,
                //                   );

                //                   print('out');
                //                 },
                //                 child: Container(
                //                     height: 60,
                //                     width: width * 0.8,
                //                     // margin: EdgeInsets.all(100.0),
                //                     decoration: BoxDecoration(
                //                         color: Color(0xFF101010),
                //                         shape: BoxShape.rectangle,
                //                         borderRadius: BorderRadius.all(
                //                             Radius.circular(25.0))),
                //                     child: Center(
                //                       child: Text(
                //                         'الانتهاء من الطلب',
                //                         style: TextStyle(
                //                             color: AppColors.primaryColor),
                //                       ),
                //                     )))
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
                ),
            // showChatStack
            //     ? Chat(
            //         order: widget.order,
            //         deliveryId: widget.order.driverId.toString(),
            //         peerAvatar: widget.order.user.imagePath,
            //         peerId: widget.order.userId.toString(),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
// Future<String> displayPrediction(Prediction p) async {
//   if (p != null) {
//     PlacesDetailsResponse detail =
//         await _places.getDetailsByPlaceId(p.placeId);
//     var placeId = p.placeId;
//     double lat = detail.result.geometry.location.lat;
//     double lng = detail.result.geometry.location.lng;
//     var address = await Geocoder.local.findAddressesFromQuery(p.description);
//     _addMarker(new LatLng(lat, lng));
//     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         bearing: 192.8334901395799,
//         target: new LatLng(lat, lng),
//         // tilt: 59.440717697143555,
//         zoom: 20)));
//   }
// }
