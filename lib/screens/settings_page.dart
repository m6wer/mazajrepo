import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/main.dart';
import 'package:Mazaj/model/deliveryuser.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/screens/termsAndPolicies.dart';
import 'package:Mazaj/services/general%20apis/push_notifications.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:Mazaj/services/general%20apis/updateuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../constants/globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final picker = ImagePicker();
  File _image;
  String base64Image;
  bool _lights;
  TextEditingController _c = TextEditingController();
  TextEditingController _stcpay = TextEditingController();

  Future getImage() async {
    ImageSource source;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Theme(
          data: ThemeData.dark(),
          child: AlertDialog(
            elevation: 3,
            titleTextStyle: TextStyle(fontFamily: "GE_SS_Two"),
            contentTextStyle: TextStyle(fontFamily: "GE_SS_Two"),
            title: Text(
              "حدد مصدر الصورة",
              textAlign: TextAlign.center,
            ),
            content: Text(
              "رجاء حدد مصدر الصورة",
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 50),
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.linked_camera,
                  color: AppColors.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    source = ImageSource.camera;
                  });
                  Navigator.pop(context);
                },
              ),
              Builder(
                builder: (context) {
                  return FlatButton(
                    child: Icon(
                      Icons.photo_library,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        source = ImageSource.gallery;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              )
              // usually buttons at the bottom of the dialog
              ,
            ],
          ),
        );
      },
    ).then((value) async {
      var image = await picker.getImage(source: source);
      List<int> imageBytes = File(image.path).readAsBytesSync();
      if (image != null) {
        setState(() {
          _image = File(image.path);
          base64Image = base64Encode(imageBytes);
          print('Encoded Image here $base64Image');
        });
        await updateuserApi(
            context: context,
            image64: base64Image,
            stcpay: deliveryUserInfo.stcpay,
            type: 'image',
            phone: deliveryUserInfo.phone);
      }
      return base64Encode(imageBytes);
    });
  }

  initialize() async {
    String notificationsBool = await readData(key: 'notificationsBool');
    if (notificationsBool == null) {
      setState(() {
        _lights = true;
        PushNotificationService().initialise();
      });
    } else if (notificationsBool == 'true') {
      setState(() {
        _lights = true;
        PushNotificationService().initialise();
      });
    } else {
      setState(() {
        _lights = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _c = TextEditingController();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DeliveryHome()));
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
              title: Text("الإعدادات",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              centerTitle: true,
            ),
            body: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                height: height,
                width: width,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => getImage(),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                deliveryUserInfo.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "GE_SS_Two",
                                  color: AppColors.ligthGrey,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                ' المملكة العربية السعودية',
                                style: TextStyle(
                                    color: AppColors.lightFont, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(width: 5),
                          ConstrainedBox(
                            constraints: BoxConstraints.tight(
                                Size(width * 0.3, height * 0.15)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Positioned(
                                  top: 0.0,
                                  child: _image == null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              deliveryUserInfo.imagePath,
                                              scale: 1.5),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              deliveryUserInfo.imagePath,
                                              scale: 1.5),
                                        ),
                                ),
                                Positioned(
                                    bottom: 25,
                                    right: 15,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xFF25292E),
                                      child: SvgPicture.asset(
                                        "assets/images/cog.svg",
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.greyText,
                    ),
                    Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: MergeSemantics(
                              child: ListTile(
                                title: Text('ارسال الاشعارات '),
                                trailing: CupertinoSwitch(
                                  activeColor: AppColors.primaryColor,
                                  value: _lights,
                                  onChanged: (bool value) async {
                                    setState(() {
                                      _lights = !_lights;
                                    });
                                    await saveData(
                                        key: 'notificationsBool',
                                        saved: _lights.toString());
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    _lights = !_lights;
                                  });
                                },
                              ),
                            ))),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.greyText,
                    ),
                    GestureDetector(
                      onTap: () {
                        bool isLoading = false;
                        showDialog(
                            child: Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: new Dialog(
                                child: Container(
                                  height: height * 0.25,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text("أكتب  رقمك  المراد  التغيير  إليه"),
                                      new TextField(
                                        controller: _c,
                                        style: TextStyle(fontFamily: "Arial"),
                                        keyboardType: TextInputType.number,
                                        textDirection: ui.TextDirection.ltr,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            prefix: Text('+966',
                                                style: TextStyle(
                                                    fontFamily: "Arial")),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.redAccent,
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.darkGrey,
                                                  width: 2.0),
                                            ),
                                            hintText: 'رقم الهاتف',
                                            fillColor: AppColors.darkGrey,
                                            filled: true,
                                            suffixIcon: Icon(
                                              Icons.phone_android,
                                              color: AppColors.ligthGrey,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never),
                                      ),
                                      RaisedButton(
                                          color: AppColors.primaryColor,
                                          child: isLoading
                                              ? SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .primaryColor),
                                                  ))
                                              : Text("موافق",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          onPressed: () async {
                                            isLoading = true;
                                            updateuserApi(
                                                context: context,
                                                image64: base64Image,
                                                stcpay: deliveryUserInfo.stcpay,
                                                type: 'phone',
                                                phone: _c.text[0] == '0'
                                                    ? _c.text
                                                        .replaceFirst('0', '')
                                                    : _c.text);
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            context: context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              deliveryUserInfo.phone,
                              style: TextStyle(
                                  fontFamily: "Arial",
                                  fontSize: 12,
                                  color: AppColors.lightFont),
                            ),
                            Text("تغيير رقم الجوال"),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.greyText,
                    ),
                    GestureDetector(
                      onTap: () {
                        bool isLoading = false;
                        showDialog(
                            child: Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: new Dialog(
                                child: Container(
                                  height: height * 0.25,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                          "المراد ربط الحساب به stcpay أكتب رقم"),
                                      new TextField(
                                        controller: _stcpay,
                                        style: TextStyle(fontFamily: "Arial"),
                                        keyboardType: TextInputType.number,
                                        textDirection: ui.TextDirection.ltr,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                            prefix: Text('+966',
                                                style: TextStyle(
                                                    fontFamily: "Arial")),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.redAccent,
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.darkGrey,
                                                  width: 2.0),
                                            ),
                                            hintText: 'stcpay رقم',
                                            fillColor: AppColors.darkGrey,
                                            filled: true,
                                            suffixIcon: Icon(
                                              Icons.phone_android,
                                              color: AppColors.ligthGrey,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never),
                                      ),
                                      RaisedButton(
                                          color: AppColors.primaryColor,
                                          child: isLoading
                                              ? SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .primaryColor),
                                                  ))
                                              : Text("موافق",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          onPressed: () async {
                                            isLoading = true;
                                            updateuserApi(
                                              context: context,
                                              image64: base64Image,
                                              phone: deliveryUserInfo.phone,
                                              type: 'stcpay',
                                              stcpay: _stcpay.text[0] == '0'
                                                  ? _stcpay.text
                                                      .replaceFirst('0', '')
                                                  : _stcpay.text,
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            context: context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              deliveryUserInfo.stcpay == null ||
                                      deliveryUserInfo.stcpay == 'null'
                                  ? 'لا يوجد رقم مربوط بهذا الحساب'
                                  : deliveryUserInfo.stcpay,
                              style: TextStyle(
                                  fontFamily: deliveryUserInfo.stcpay == null
                                      ? "GE_SS_Two"
                                      : 'Calibri',
                                  fontSize: 12,
                                  color: AppColors.lightFont),
                            ),
                            Text(
                              "stcpay تغيير رقم",
                              style: TextStyle(
                                fontFamily: 'GE_SS_Two',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.greyText,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => TermsAndPolicies(
                    //                   page: SettingsPage(),
                    //                 )));
                    //   },
                    //   child: Container(
                    //     margin:
                    //         EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Container(),
                    //         Text("الشروط و الاحكام و سياسة الخصوصية"),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ))),
      ),
    );
  }
}
