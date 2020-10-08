import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/model/comission.dart';
import 'package:Mazaj/services/delivery%20apis/getcomissions.dart';
import 'package:Mazaj/widgets/fees_card.dart';
import 'package:flutter/material.dart';
import 'package:Mazaj/screens/home/home_page.dart';

_AppFeesPageState appFeesPageState;

class AppFeesPage extends StatefulWidget {
  @override
  _AppFeesPageState createState() {
    appFeesPageState = _AppFeesPageState();
    return appFeesPageState;
  }
}

List<Orders> comissionList = [];
bool loadingComission = false;

class _AppFeesPageState extends State<AppFeesPage> {
  @override
  void initState() {
    comissionList.clear();
    loadingComission = false;
    getcomissionsApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text("عمولة التطبيق",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              centerTitle: true,
            ),
            body: loadingComission
                ? ListView.builder(
                    itemCount: comissionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FeesCard(
                        notification: comissionList[index],
                      );
                    },
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
