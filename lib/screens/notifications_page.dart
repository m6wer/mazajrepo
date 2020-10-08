import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/notification.dart';
import 'package:Mazaj/widgets/notification_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:flutter_svg/svg.dart';

class NotificatiosPage extends StatefulWidget {
  @override
  _NotificatiosPageState createState() => _NotificatiosPageState();
}

class _NotificatiosPageState extends State<NotificatiosPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainGreyColor,
          iconTheme: IconThemeData(color: Colors.white, size: 10),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("الاشعارات",
              style: TextStyle(color: Colors.white, fontSize: 14)),
          centerTitle: true,
        ),
        body: FutureBuilder<List<NotificationModel>>(
          // future: HomeRepo().getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Container(
                  height: height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/images/notificationsPlaceHolder.svg",
                          height: 100,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "لا يوجد لديك اشعارات بعد\n",
                              children: [
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
                                  fontFamily: "GE_SS_Two",
                                  height: 2)),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: NotificationCard(
                        notification: snapshot.data[index],
                      ),
                    );
                  },
                );
              }
            } else {
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.mainGreyColor),
                      backgroundColor: AppColors.primaryColor,
                    )),
              );
            }
          },
        ));
  }
}
