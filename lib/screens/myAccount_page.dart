import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/clipper.dart';
import 'package:Mazaj/main.dart';
import 'package:Mazaj/model/deliveryuser.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/services/general%20apis/sharedPreference.dart';
import 'package:Mazaj/services/general%20apis/updateuser.dart';
import 'dart:convert';
import 'dart:io';
import '../constants/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final picker = ImagePicker();
  File _image;
  String base64Image;
  User currentUser;
  bool isLoading = false;

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
              "رجاءاً حدد مصدر الصورة",
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
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        setState(() {
          _image = File(image.path);
          base64Image = base64Encode(imageBytes);
          print('Encoded Image here $base64Image');
        });
        updateuserApi(
            context: context,
            image64: base64Image,
            type: 'image',
            phone: deliveryUserInfo.phone);
      }
    });
  }

  void setUser() async {
    User user = User(
      stcpay: deliveryUserInfo.stcpay,
      code: deliveryUserInfo.code,
      createdAt: deliveryUserInfo.createdAt,
      // email: deliveryUserInfo.email,
      emailVerifiedAt: deliveryUserInfo.emailVerifiedAt,
      id: deliveryUserInfo.id,
      image: deliveryUserInfo.image,
      imagePath: base64Image,
      mobileToken: deliveryUserInfo.mobileToken,
      name: deliveryUserInfo.name,
      phone: deliveryUserInfo.phone,
      updatedAt: deliveryUserInfo.updatedAt,
    );
    await saveData(key: 'user', saved: jsonEncode(user));
    print(await json.decode(readData(key: 'user')));
    getUser();
  }

  Future<User> getUser() async {
    Map userMapTemp = json.decode(readData(key: 'user'));
    print(userMapTemp);
    User user = User.fromJson(userMapTemp);

    currentUser = User.fromJson(userMapTemp);
    print(json.encode(currentUser));
    return user;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              title: Text("حسابي",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              centerTitle: true,
            ),
            body: Container(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.32,
                    child: ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        height: size.height * 0.32,
                        color: AppColors.blueGrey,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: size.height * 0.05,
                    child: GestureDetector(
                      onTap: () => getImage(),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints.tight(
                                Size(double.infinity, size.height * 0.2)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Positioned(
                                    top: 0.0,
                                    child: _image == null
                                        ? CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                                deliveryUserInfo.imagePath,
                                                scale: 1.5),
                                          )
                                        : CircleAvatar(
                                            radius: 60,
                                            backgroundImage: NetworkImage(
                                                deliveryUserInfo.imagePath,
                                                scale: 1.5),
                                          )),
                                Positioned(
                                    bottom: 5,
                                    right: 130,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Color(0xFF25292E),
                                      child: SvgPicture.asset(
                                        "assets/images/cog.svg",
                                        height: 30,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            deliveryUserInfo.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: "GE_SS_Two",
                              color: AppColors.ligthGrey,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.35,
                    right: size.width * 0.05,
                    left: size.width * 0.05,
                    child: Container(
                      width: size.width * 0.9,
                      color: AppColors.blueGrey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InfoTile(
                              title: "رقم الجوال",
                              value: deliveryUserInfo.phone,
                              image: "assets/images/mobile.svg",
                            ),
                            // InfoTile(
                            //   title: "البريد الإلكترونى",
                            //   value: deliveryUserInfo.email,
                            //   image: "assets/images/email.svg",
                            // ),
                            InfoTile(
                              title: "stcpay رقم",
                              value: deliveryUserInfo.stcpay == null ||
                                      deliveryUserInfo.stcpay == 'null'
                                  ? 'لا يوجد رقم مربوط بهذا الحساب'
                                  : deliveryUserInfo.stcpay,
                              image: "assets/images/mobile.svg",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String image;

  const InfoTile({Key key, this.title, this.value, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListTile(
          leading: SvgPicture.asset(
            image,
            color: AppColors.primaryColor,
            height: 15,
          ),
          title: Text(
            "$title",
            style: TextStyle(fontFamily: "GE_SS_Two"),
          ),
          subtitle: Text(
            "$value",
            style: TextStyle(fontFamily: "GE_SS_Two"),
          ),
        ),
      ),
    );
  }
}
