import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/clipper.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/services/general%20apis/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/general apis/push_notifications.dart';
import '../../services/general apis/sharedPreference.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo;
  bool isLoading = false;
  BuildContext globalContext;

  loginWithMobile() async {
    if (phoneNo.trim().length == 0) {
      ShowToast.showToast(globalContext, "يجب كتابة رقم الهاتف");
      return;
    }
    if (phoneNo.trim().length < 9) {
      ShowToast.showToast(globalContext, "رقم الهاتف قصير");
      return;
    }

    try {
      setState(() {
        isLoading = true;
        print(phoneNo);
      });
      await loginApi(context: context, phoneNumber: phoneNo);
    } catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Form(
          child: Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   final deliveryUserToken = await readData(key: 'token');
        //   print("deliveryUserToken: $deliveryUserToken");
        //   print(await readData(key: 'user'));
        //   String mobileToken = await PushNotificationService().getToken();
        //   print("mobileToken: $mobileToken");
        // }),
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(color: Colors.black),
          child: Stack(
            children: <Widget>[
              Container(
                height: height * 0.4,
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: height * 0.5,
                    color: Colors.white,
                    child: Container(
                      height: height * 0.5,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/mazajlogo.png',
                            fit: BoxFit.contain,
                            scale: 0.5,
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: height * 0.45,
                  child: Container(
                      width: width,
                      height: height * 0.6,
                      // color: AppColors.blueGrey,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Stack(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[Text("اهلا بك في فريقنا")],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(22),
                                                color: AppColors.darkGrey,
                                                child: Text(
                                                  "+966",
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                  width: width * 0.6,
                                                  child: TextField(
                                                    onSubmitted: (value) {
                                                      phoneNo = value;
                                                      setState(() {
                                                        phoneNo[0] == '0' ? phoneNo = phoneNo.replaceFirst('0', '') : phoneNo = phoneNo;
                                                      });
                                                      loginWithMobile();
                                                    },
                                                    style: TextStyle(fontFamily: "Arial"),
                                                    keyboardType: TextInputType.number,
                                                    textDirection: TextDirection.rtl,
                                                    textAlign: TextAlign.right,
                                                    onChanged: (String value) {
                                                      phoneNo = value;
                                                    },
                                                    decoration: InputDecoration(
                                                        focusedErrorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: AppColors.darkGrey, width: 2.0),
                                                        ),
                                                        hintText: 'رقم الهاتف',
                                                        fillColor: AppColors.darkGrey,
                                                        filled: true,
                                                        suffixIcon: Icon(
                                                          Icons.phone_android,
                                                          color: AppColors.ligthGrey,
                                                        ),
                                                        floatingLabelBehavior: FloatingLabelBehavior.never),
                                                  )),
                                            ],
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Positioned(
                                      right: MediaQuery.of(context).size.width * 0.1,
                                      left: MediaQuery.of(context).size.width * 0.1,
                                      top: height * 0.18,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                                        child: Container(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            height: 50,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0), side: BorderSide(color: Theme.of(context).primaryColor)),
                                              onPressed: isLoading ? null : loginWithMobile,
                                              color: Theme.of(context).primaryColor,
                                              child: isLoading
                                                  ? SizedBox(
                                                      height: 10.0,
                                                      width: 10.0,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                                      ))
                                                  : Text(
                                                      "دخول",
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0, color: Colors.black),
                                                    ),
                                            )),
                                      )),
                                  Positioned(
                                    top: height * 0.28,
                                    right: width * 0.1,
                                    left: width * 0.1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                                      child: Text(
                                        "سنرسل لك رمز التفعيل لتوثيق الحساب ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      )),
    );
  }
}
