import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Mazaj/model/deliveryuser.dart';
import 'package:Mazaj/screens/auth/login_page.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/general apis/push_notifications.dart';

User deliveryUserInfo;
String deliveryUserToken;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String mobile_token = await PushNotificationService().getToken();
    // print(mobile_token);
    print(await prefs.getString('token'));
    setState(() {
      deliveryUserToken = prefs.getString('token') ?? null;
      if (deliveryUserToken != null) {
        String userMap = prefs.getString('user');
        deliveryUserInfo = User.fromJson(json.decode(userMap));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Mazaj',
      debugShowCheckedModeBanner: false,
      locale: Locale('ar'),
      theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
              bodyText1: TextStyle(
                  fontSize: 14.0, color: Colors.white, fontFamily: "Arial")),
          primaryColor: Color(0xFFFFF930),
          fontFamily: "GE_SS_Two"),
      home: deliveryUserToken == null ? LoginPage() : DeliveryHome(),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   SharedPref sharedPref = SharedPref();
//   checkLogin() async {
//     String mobile_token = await PushNotificationService().getToken();
//     print(mobile_token);
//     deliveryUserToken = await readData(key: 'token');
//     print(deliveryUserToken);
//     print(await readData(key: 'user'));
//     if (deliveryUserToken == null) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => LoginPage()));
//     } else {
//       String userMap = await readData(key: 'user');
//       deliveryUserInfo = User.fromJson(json.decode(userMap));
//       print(json.encode(deliveryUserInfo));
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => DeliveryHome(
//             landingPage: 'available',
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     Future.delayed(Duration(milliseconds: 500), checkLogin);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Image.asset(
//             'assets/images/mazajlogo.png',
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
