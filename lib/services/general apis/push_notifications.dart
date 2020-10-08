import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibration/vibration.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> getToken() async {
    return _fcm.getToken();
  }

  Future initialise() async {
    // Future<void> audioOnInit() async {
    //   await FlutterRadio.play(url: streamUrl);
    //   print('Audio Start On Init OK');
    // }

    // audioOnInit();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    if (Platform.isIOS) _fcm.requestNotificationPermissions(IosNotificationSettings());
    _fcm.getToken().then((val) {
      print("User Token: $val");
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print(message);
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }
      },
    );
  }
}
