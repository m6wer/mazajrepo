import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/comission.dart';
import 'package:flutter/material.dart';

class FeesCard extends StatelessWidget {
  final Orders notification;

  const FeesCard({this.notification});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.darkGrey,
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "تم استخدام التطبيق في هذا اليوم  برجاء سداد  مبلغ ",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  RichText(
                      // textAlign: TextAlign.right,
                      text: TextSpan(
                          text: "ريال",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "GE_SS_Two",
                              color: Colors.white),
                          children: [
                        TextSpan(
                          text: notification.commission,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Arial",
                              color: AppColors.primaryColor),
                        )
                      ]))
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 1.0,
              height: 40.0,
              child: Container(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    notification.day,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontFamily: "Arial",
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    notification.month,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
