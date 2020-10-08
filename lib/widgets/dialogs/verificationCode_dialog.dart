import 'dart:convert';
import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/screens/home/home_page.dart';
import 'package:Mazaj/services/general%20apis/checkCode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../services/general apis/sharedPreference.dart';
import 'dart:ui' as ui;

class VerificationCodeDialog extends StatefulWidget {
  final String phone;

  const VerificationCodeDialog({this.phone});
  @override
  _VerificationCodeDialogState createState() => _VerificationCodeDialogState();
}

class _VerificationCodeDialogState extends State<VerificationCodeDialog> {
  String phone;
  TextEditingController code = TextEditingController();
  bool isLoading = false;
  bool isVerifying = false;
  BuildContext customContext;
  @override
  void initState() {
    phone = widget.phone;
    super.initState();
  }

  // verify(String phone, String code) async {
  //   if (code.trim().length < 4) {
  //     return;
  //   }
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     print(dUser);
  //   } catch (e) {
  //     ShowToast.showToast(context, e.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    customContext = context;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: height * 0.15, horizontal: 30),
            child: Container(
              color: Color(0xFF030303),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.16,
                    color: Color(0xFF393D46),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text(
                          'سنرسل لك رمز التفعيل على الرقم\n ',
                          textDirection: ui.TextDirection.ltr,
                          style: TextStyle(
                              fontFamily: "GE_SS_Two", color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              phone,
                              textDirection: ui.TextDirection.ltr,
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Arial"),
                            ),
                            Text("  تعديل الرقم؟",
                                textDirection: ui.TextDirection.ltr,
                                style: TextStyle(
                                    fontFamily: "GE_SS_Two",
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isVerifying
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor),
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: TextField(
                              controller: code,
                              style: TextStyle(fontFamily: "Arial"),
                              keyboardType: TextInputType.number,
                              textDirection: ui.TextDirection.ltr,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.darkGrey, width: 2.0),
                                  ),
                                  hintText: 'كود التأكيد',
                                  hintStyle: TextStyle(fontFamily: 'GE_SS_Two'),
                                  fillColor: AppColors.darkGrey,
                                  filled: true,
                                  suffixIcon: Icon(
                                    Icons.sms,
                                    color: AppColors.ligthGrey,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      child: RaisedButton(
                        color: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        onPressed: () async {
                          if (code.text.length == 4) {
                            setState(() {
                              isVerifying = true;
                            });

                            await checkUserCode(
                                cameFrom: '',
                                context: context,
                                phone: phone,
                                code: code.text);
                            String token = await readData(key: 'token');
                            // User x = User.fromJson(jsonDecode(prefs.getString('user')));
                            // x = await User.fromJson(json.decode(prefs.getString('user')));
                            // print(x.email);
                            // print(x.email);
                            setState(() {
                              isVerifying = false;
                            });
                            if (token != null) {
                              print('not null token');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DeliveryHome(
                                            landingPage: 'available',
                                          )));
                            } else {
                              setState(() {
                                isVerifying = false;
                              });
                              print('error');
                            }
                          } else {
                            ShowToast.showToast(context, "الكود غير صحيح",
                                backgroundColor: Colors.red,
                                duration: 3,
                                gravity: 0,
                                textColor: Colors.white);
                          }
                        },
                        child: Center(
                          child: Text(
                            'تأكيد الرمز',
                            style: TextStyle(
                              fontFamily: 'GE_SS_Two',
                              fontSize: 14,
                              color: const Color(0xff4d4a47),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color(0xfffff930),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
