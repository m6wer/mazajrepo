import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/notification.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({this.notification});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkGrey.withOpacity(0.30),
      elevation: 4.0,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 5,
                left: 10,
                child: Text(
                  "${notification.day} - ${notification.month} - ${notification.time}",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontFamily: "Arial"),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Center(
                                child: ListTile(
                                    // contentPadding: EdgeInsets.all(10),
                                    dense: true,
                                    title: Text(
                                      notification.title,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.asset(
                                          "assets/images/delivery.png"),
                                    ),
                                    subtitle: Text(
                                      notification.body,
                                    ),
                                    onTap: () {}),
                              ))),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
