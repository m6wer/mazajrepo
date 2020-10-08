import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/services/general%20apis/getuser.dart';
import 'package:flutter/gestures.dart';
// import 'package:Mazaj/widgets/customDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

_WalletPageState walletPageState;
bool walletload = false;
String wallet = '0';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() {
    walletPageState = _WalletPageState();
    return walletPageState;
  }
}

class _WalletPageState extends State<WalletPage> {
  initialize() async {
    walletload = false;
    await getUser();
  }

  @override
  void initState() {
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DeliveryHome()));
      },
      child: SafeArea(
        child: Scaffold(
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
              title: Text("محفظتي",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              centerTitle: true,
            ),
            // endDrawer: CustomSideDrawer(),
            body: walletload
                ? Container(
                    height: height,
                    width: width,
                    margin: EdgeInsets.only(top: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/images/wallet.svg",
                          height: 110,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "$wallet SAR\n",
                              children: [
                                TextSpan(
                                    text: "استخدم محفظتك في طلبك القادم\n",
                                    style: TextStyle(
                                        color: AppColors.lightFont,
                                        fontSize: 14,
                                        fontFamily: "GE_SS_Two",
                                        height: 2)),
                                TextSpan(
                                    text: "الصفحة الرئيسية",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    DeliveryHome()));
                                      },
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "GE_SS_Two",
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline))
                              ],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Arial",
                                  height: 2)),
                        )
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        height: 3,
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.mainGreyColor),
                          backgroundColor: AppColors.primaryColor,
                        )),
                  )),
      ),
    );
  }
}
