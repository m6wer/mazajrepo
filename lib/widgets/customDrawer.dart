import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/main.dart';
import 'package:Mazaj/model/deliveryuser.dart';
import 'package:Mazaj/screens/myAccount_page.dart';
import 'package:Mazaj/services/general%20apis/signout.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:Mazaj/screens/settings_page.dart';
import 'package:Mazaj/screens/wallet_page.dart';
import 'package:Mazaj/widgets/sideDrawerListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSideDrawer extends StatefulWidget {
  @override
  _CustomSideDrawerState createState() => _CustomSideDrawerState();
}

bool isLoggingOut = false;

class _CustomSideDrawerState extends State<CustomSideDrawer> {
  DeliveryUser currentUser;

  // confirmation function to agree or disagree logout user .
  void _showDialog() {
    // flutter defined function
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
            title: Text("تسجيل الخروج"),
            content: Text("هل تريد تسجيل الخروج الآن ؟"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "إلغاء",
                  style: TextStyle(fontFamily: "GE_SS_Two"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Builder(
                builder: (context) {
                  return FlatButton(
                    child: Text(
                      "تأكيد",
                      style: TextStyle(fontFamily: "GE_SS_Two"),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoggingOut = true;
                      });
                      signoutApi(context: context);
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
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Drawer(
        child: Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 17,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 24,
                  ))),
          Positioned(
              top: 50,
              right: 0,
              left: 0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  100.0) //         <--- border radius here
                              ),
                          image: DecorationImage(
                            image: NetworkImage(deliveryUserInfo.imagePath,
                                scale: 1.5),
                            fit: BoxFit.cover,
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    deliveryUserInfo.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    ' المملكة العربية السعودية',
                    style: TextStyle(color: AppColors.lightFont, fontSize: 12),
                  ),
                ],
              )),
          Positioned(
            right: 50,
            left: 0,
            top: MediaQuery.of(context).size.height * 0.33,
            child: Align(
              alignment: Alignment.center,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    SideDrawerListTile(
                      title: "الرئيسية",
                      icon: SvgPicture.asset(
                        "assets/images/home.svg",
                        height: 16,
                        color: AppColors.primaryColor,
                      ),
                      onClick: () {
                        // setState(() {
                        //   _currentIndex = 0;
                        // });
                        Navigator.of(context).pop();
                      },
                    ),
                    // SideDrawerListTile(
                    //   title: "الطلبات",
                    //   icon: SvgPicture.asset(
                    //     "assets/images/orders.svg",
                    //     height: 16,
                    //     color: AppColors.primaryColor,
                    //   ),
                    //   onClick: () {
                    //     Navigator.of(context).pop();
                    //   },
                    // ),
                    SideDrawerListTile(
                      title: "ملفي الشخصي",
                      icon: SvgPicture.asset(
                        "assets/images/user.svg",
                        height: 16,
                        color: AppColors.primaryColor,
                      ),
                      onClick: () {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (builder) => MyAccountPage()));
                      },
                    ),
                    // SideDrawerListTile(
                    //   title: "عمولة التطبيق",
                    //   icon: SvgPicture.asset(
                    //     "assets/images/cash.svg",
                    //     height: 16,
                    //     color: AppColors.primaryColor,
                    //   ),
                    //   onClick: () async {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         CupertinoPageRoute(
                    //             fullscreenDialog: true,
                    //             builder: (builder) => AppFeesPage()));
                    //   },
                    // ),
                    SideDrawerListTile(
                      title: "محفظتي",
                      icon: SvgPicture.asset(
                        "assets/images/wallet.svg",
                        height: 16,
                        color: AppColors.primaryColor,
                      ),
                      onClick: () {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (builder) => WalletPage()));
                      },
                    ),

                    //  Intent telegram = new Intent(Intent.ACTION_VIEW , Uri.parse("https://telegram.me/InfotechAvl_bot"));
                    //  startActivity(telegram);

                    SideDrawerListTile(
                      title: "الاعدادات",
                      icon: SvgPicture.asset(
                        "assets/images/settings.svg",
                        height: 16,
                        color: AppColors.primaryColor,
                      ),
                      // launch("tel://" + tech.adminPhone);
                      onClick: () {
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (builder) => SettingsPage()));
                      },
                    ),
                    SideDrawerListTile(
                      title: "الدعم الفنى",
                      icon: Image.asset(
                        "assets/images/whatsapp.png",
                        height: 16,
                        // color: AppColors.primaryColor,
                      ),
                      onClick: () async {
                        if (LocalPlatform().isAndroid) {
                          final AndroidIntent intent = AndroidIntent(
                              action: 'action_view',
                              data: Uri.encodeFull(
                                  'https://api.whatsapp.com/send?phone=+966509069542'),
                              package: 'com.whatsapp');
                          intent.launch();
                        } else {
                          String url =
                              "https://api.whatsapp.com/send?phone=+966509069542";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                    ),
                    SideDrawerListTile(
                      title: "تسجيل الخروج",
                      icon: SvgPicture.asset(
                        "assets/images/sign-out.svg",
                        height: 16,
                        color: AppColors.primaryColor,
                      ),
                      onClick: () {
                        print("Clicked!");
                        _showDialog();
                      },
                    ),
                  ]),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "حساباتنا",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset("assets/images/snapchat.svg"),
                      onPressed: () =>
                          _launchURL("https://www.snapchat.com/add/mazajasly"),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/images/twitter.svg"),
                      onPressed: () =>
                          _launchURL("https://twitter.com/mazajasly"),
                    ),
                    // IconButton(
                    //   icon: SvgPicture.asset("assets/images/facebook.svg"),
                    //   onPressed: () =>
                    //       _launchURL("https://www.facebook.com/humhumapp"),
                    // ),
                    IconButton(
                      icon: SvgPicture.asset("assets/images/instagram.svg"),
                      onPressed: () =>
                          _launchURL("https://www.instagram.com/mazajasly/"),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
