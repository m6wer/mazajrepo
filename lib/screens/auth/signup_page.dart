import 'dart:io';
import 'package:Mazaj/Theme/app_colors.dart';
import 'package:Mazaj/Theme/toast.dart';
import 'package:Mazaj/screens/auth/login_page.dart';
import 'package:Mazaj/services/general%20apis/registeration.dart';
import 'package:Mazaj/widgets/photo_picker_row.dart';
import 'package:Mazaj/widgets/text_feilds/main_input_feild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

bool loadingRegisteration = false;
_SignupPageState signupPageState;

class SignupPage extends StatefulWidget {
  final String phoneNo;
  SignupPage({this.phoneNo});
  @override
  _SignupPageState createState() {
    signupPageState = _SignupPageState();
    return signupPageState;
  }
}

class _SignupPageState extends State<SignupPage> {
  bool isSigning = false;
  File _userImage;
  File _idImage;
  File _contractImage;
  File _licncesImage;
  File _carFrontImage;
  File _carBackImage;
  String name = "";
  String email = "";
  String stcpay = "";
  String stcNo = "";
  String idNo = "";
  String carNo = "";
  String carLetters = '', carNumbers = '';
  bool isLoading = false;
  TextEditingController stcController = TextEditingController();
  List labels = ["ذكر", "أنثى"];
  var _value;
  final picker = ImagePicker();
  Future pickUserImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _userImage = File(image.path);
      });
    }
  }

  // Future<void> callServerToSignUp() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await AuthRepo().signUp(
  //       carBackPic: _carBackImage,
  //       carFrontPic: _carFrontImage,
  //       contractPic: _contractImage,
  //       carNo: carNo,
  //       idPic: _idImage,
  //       licensePic: _licncesImage,
  //       profilePic: _userImage,
  //       email: email,
  //       gender: labels[_value],
  //       name: name,
  //       phoneNo: widget.phoneNo,
  //       stcNo: stcNo,
  //     );
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (_) => DeliveryHome()));
  //   } catch (e) {
  //     print(e);
  //     ShowToast.showToast(context, e,
  //         backgroundColor: Colors.redAccent.withOpacity(0.8),
  //         textColor: Colors.white);
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  void signUp(BuildContext context) async {
    // validat input feilds then photos then call the server
    // if (stcNo.trim().length == 0) {
    //   ShowToast.showToast(context, 'لا تترك رقم stc فارغ');
    //   return;
    // }
    if (name.trim().length == 0) {
      ShowToast.showToast(context, 'لا تترك خانه الاسم فارغة',
          backgroundColor: Colors.red, gravity: 0);
      return;
    }
    // if (email.trim().length == 0) {
    //   ShowToast.showToast(context, 'لا تترك البريد الالكتروني فارغ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    // bool emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(email);
    // if (!emailValid) {
    //   ShowToast.showToast(context, 'اكتب البريد الالكتروني بطريقة صحيحة',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    if (carLetters.trim().length == 0) {
      ShowToast.showToast(context, 'لا تترك حروف المركبة  فارغة',
          backgroundColor: Colors.red, gravity: 0);
      return;
    }
    // if (carNumbers.trim().length == 0) {
    //   ShowToast.showToast(context, 'لا تترك أرقام المركبة  فارغة',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    if (carLetters.trim().length != 0
        // && carNumbers.trim().length != 0
        ) {
      carNo = carLetters + carNumbers;
    }
    // if (_value == null) {
    //   ShowToast.showToast(context, 'يجب اختيار نوع ذكر او انثي ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    // validate photos
    // if (_userImage == null) {
    //   ShowToast.showToast(context, 'يجب اختيار صورة شخصية ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    if (_idImage == null) {
      ShowToast.showToast(context, 'يجب اختيار صورة الهويه الوطنية ',
          backgroundColor: Colors.red, gravity: 0);
      return;
    }
    // if (_contractImage == null) {
    //   ShowToast.showToast(context, 'يجب اختيار صورة الاستمارة ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    // if (_licncesImage == null) {
    //   ShowToast.showToast(context, 'يجب اختيار صورة رخصه القيادة ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    // if (_carFrontImage == null) {
    //   ShowToast.showToast(context, 'يجب اختيار صورة المركبة من الامام ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    // if (_carBackImage == null) {
    //   ShowToast.showToast(context, 'يجب اختيار صورة المركبة من الخلف ',
    //       backgroundColor: Colors.red, gravity: 0);
    //   return;
    // }
    if (idNo.trim().length != 10) {
      ShowToast.showToast(context, 'ادخل رقم الهوية صحيح',
          backgroundColor: Colors.red, gravity: 0);
      return;
    }
    // callServerToSignUp();
    setState(() {
      isSigning = true;
    });
    await signupApi(
      context: context,
      idNo: idNo,
      carBackPic: _carBackImage,
      carFrontPic: _carFrontImage,
      carNo: carNo,
      contractPic: _contractImage,
      // email: email,
      gender: 'male',
      idPic: _idImage,
      licensePic: _licncesImage,
      name: name,
      phoneNo: widget.phoneNo,
      profilePic: _userImage,
      stcNo: stcController.text.isNotEmpty
          ? stcController.text[0] == '0'
              ? stcController.text = stcController.text.replaceFirst('0', '')
              : stcController.text = stcController.text
          : 'null',
    );
    setState(() {
      isSigning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // isLoading = false;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: InkWell(
                        onTap: pickUserImage,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tight(
                              Size(size.width * 50, size.height * 0.2)),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Positioned(
                                  top: 0.0,
                                  child: Container(
                                    padding: _userImage == null
                                        ? EdgeInsets.only(
                                            top: size.height * 0.03)
                                        : null,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: size.aspectRatio * 120,
                                      backgroundImage: _userImage == null
                                          ? AssetImage(
                                              'assets/images/avatar.png')
                                          : FileImage(
                                              _userImage,
                                            ),
                                    ),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'صورة شخصية',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.ligthGrey,
                        ),
                      ),
                    ),
                    MainInputFeild(
                      enabled: false,
                      controller: TextEditingController(text: widget.phoneNo),
                      hintText: 'رقم الهاتف',
                      suffixIcon: Icon(
                        Icons.phone_android,
                        color: AppColors.ligthGrey,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(22),
                              color: Color(0xFF302F2F),
                              child: Text(
                                "+966",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: TextField(
                                controller: stcController,
                                style: TextStyle(fontFamily: "Arial"),
                                keyboardType: TextInputType.number,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  fillColor: Color(0xFF302F2F),
                                  filled: true,
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
                                  hintText: 'stcpay رقم',
                                  suffixIcon: Icon(
                                    Icons.phone_android,
                                    color: AppColors.ligthGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MainInputFeild(
                      onChanged: (String value) {
                        name = value;
                      },
                      hintText: 'الاسم',
                      suffixIcon: Icon(
                        Icons.person,
                        color: AppColors.ligthGrey,
                      ),
                    ),
                    // MainInputFeild(
                    //   onChanged: (String value) {
                    //     stcNo = value;
                    //   },
                    //   hintText: 'stc pay  رقم',
                    //   suffixIcon: Icon(
                    //     Icons.mail_outline,
                    //     color: AppColors.ligthGrey,
                    //   ),
                    // ),
                    MainInputFeild(
                      number: true,
                      onChanged: (String value) {
                        idNo = value;
                      },
                      hintText: 'رقم الهوية',
                      suffixIcon: Icon(
                        Icons.card_membership,
                        color: AppColors.ligthGrey,
                      ),
                    ),
                    // MainInputFeild(
                    //   onChanged: (String value) {
                    //     email = value;
                    //   },
                    //   hintText: 'البريد الالكتروني',
                    //   suffixIcon: Icon(
                    //     Icons.mail_outline,
                    //     color: AppColors.ligthGrey,
                    //   ),
                    // ),
                    PhotoPickerRow(
                      title: 'صورة الهوية الوطنية / الاقامة',
                      hint: 'معلوماتك وخصوصياتك في امان',
                      onPhotoChanged: (File file) {
                        _idImage = file;
                      },
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 10),
                    //   child: Text(
                    //     "النوع",
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    // ),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Wrap(
                    //     spacing: 20.0,
                    //     runSpacing: 5.0,
                    //     children: List<Widget>.generate(
                    //       2,
                    //       (int index) {
                    //         return Theme(
                    //             data: ThemeData(
                    //               brightness: Brightness.dark,
                    //             ), // or shorthand => ThemeData.dark()
                    //             child: FilterChip(
                    //               showCheckmark: false,
                    //               labelPadding: EdgeInsets.symmetric(
                    //                   horizontal: 50, vertical: 10),
                    //               disabledColor: Colors.grey,
                    //               selectedColor: AppColors.primaryColor,
                    //               elevation: 3,
                    //               labelStyle: TextStyle(color: Colors.white),
                    //               label: Text(
                    //                 '${labels[index]}',
                    //                 style: TextStyle(
                    //                     color: _value == index
                    //                         ? Colors.black
                    //                         : Colors.white,
                    //                     fontFamily: "GE_SS_Two"),
                    //               ),
                    //               selected: _value == index,
                    //               onSelected: (bool selected) {
                    //                 setState(() {
                    //                   _value = selected ? index : null;
                    //                   print(_value);
                    //                   // print("${labels[index]}");
                    //                 });
                    //               },
                    //             ));
                    //       },
                    //     ).toList(),
                    //   ),
                    // ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'معلومات المركبة',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Icon(Icons.directions_car)
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: MainInputFeild(
                              number: true,
                              onChanged: (String value) {
                                carNumbers = value;
                              },
                              hintText: 'رقم المركبة',
                              suffixIcon: Icon(
                                Icons.directions_car,
                                color: AppColors.ligthGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: MainInputFeild(
                              onChanged: (String value) {
                                carLetters = value;
                              },
                              hintText: 'حروف المركبة',
                              suffixIcon: Icon(
                                Icons.directions_car,
                                color: AppColors.ligthGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PhotoPickerRow(
                      title: 'صورة استمارة',
                      hint: 'يجب ان تكون الاستمارة سارية المفعول',
                      onPhotoChanged: (File file) {
                        setState(() {
                          _contractImage = file;
                        });
                      },
                    ),
                    PhotoPickerRow(
                      title: 'صورة رخصه القيادة',
                      hint: 'يجب ان تكون الرخصه سارية المفعول',
                      onPhotoChanged: (File file) {
                        _licncesImage = file;
                      },
                    ),
                    PhotoPickerRow(
                      title: 'صورة المركبة من الامام',
                      onPhotoChanged: (File file) {
                        _carFrontImage = file;
                      },
                    ),
                    PhotoPickerRow(
                      title: 'صورة المركبة من الخلف',
                      onPhotoChanged: (File file) {
                        _carBackImage = file;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          onPressed: () => signUp(context),
                          color: Theme.of(context).primaryColor,
                          child: isSigning
                              ? SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ))
                              : Text(
                                  "تسجيل",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                      color: Colors.black),
                                ),
                        )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
