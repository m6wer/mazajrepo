class RegisterModel {
  String name;
  // String email;
  String phone;
  String stcpay;
  var image;
  String carNumber;
  String idNumber;
  String typeRole;
  String gender;
  var idCardImage;
  Car car;

  RegisterModel(
      {this.name,
      // this.email,
      this.stcpay,
      this.phone,
      this.image,
      this.carNumber,
      this.idNumber,
      this.typeRole,
      this.gender,
      this.idCardImage,
      this.car});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // email = json['email'];
    phone = json['phone'];
    image = json['image'];
    stcpay = json['stcpay'];
    carNumber = json['car_number'];
    idNumber = json['id_number'];
    typeRole = json['type_role'];
    gender = json['gender'];
    idCardImage = json['id_card_image'];
    car = json['car'] != null ? new Car.fromJson(json['car']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    // data['email'] = this.email;
    data['phone'] = this.phone;
    data['stcpay'] = this.stcpay;
    data['image'] = this.image;
    data['car_number'] = this.carNumber;
    data['id_number'] = this.idNumber;
    data['type_role'] = this.typeRole;
    data['gender'] = this.gender;
    data['id_card_image'] = this.idCardImage;
    if (this.car != null) {
      data['car'] = this.car.toJson();
    }
    return data;
  }
}

class Car {
  var formImg;
  var licenseImg;
  var frontImg;
  var backImg;

  Car({this.formImg, this.licenseImg, this.frontImg, this.backImg});

  Car.fromJson(Map<String, dynamic> json) {
    formImg = json['form_img'];
    licenseImg = json['license_img'];
    frontImg = json['front_img'];
    backImg = json['back_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['form_img'] = this.formImg;
    data['license_img'] = this.licenseImg;
    data['front_img'] = this.frontImg;
    data['back_img'] = this.backImg;
    return data;
  }
}
