class DeliveryUser {
  String tokenType;
  String accessToken;
  String expiresAt;
  User user;

  DeliveryUser({this.tokenType, this.accessToken, this.expiresAt, this.user});

  DeliveryUser.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    expiresAt = json['expires_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['access_token'] = this.accessToken;
    data['expires_at'] = this.expiresAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String stcpay;
  // String email;
  String emailVerifiedAt;
  String image;
  String phone;
  String mobileToken;
  String createdAt;
  String updatedAt;
  String code;
  String imagePath;
  List<Roles> roles;
  Driver driver;

  User(
      {this.id,
      this.name,
      this.stcpay,
      // this.email,
      this.emailVerifiedAt,
      this.image,
      this.phone,
      this.mobileToken,
      this.createdAt,
      this.updatedAt,
      this.code,
      this.imagePath,
      this.roles,
      this.driver});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    phone = json['phone'];
    // mobileToken = json['mobile_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stcpay = json['stcpay'];
    code = json['code'];
    imagePath = json['image_path'];
    if (json['roles'] != null) {
      roles = new List<Roles>();
      json['roles'].forEach((v) {
        roles.add(new Roles.fromJson(v));
      });
    }
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['stcpay'] = this.stcpay;
    // data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['phone'] = this.phone;
    // data['mobile_token'] = this.mobileToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['code'] = this.code;
    data['image_path'] = this.imagePath;
    if (this.roles != null) {
      data['roles'] = this.roles.map((v) => v.toJson()).toList();
    }
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    return data;
  }
}

class Roles {
  int id;
  String name;
  String guardName;
  String createdAt;
  String updatedAt;
  Pivot pivot;

  Roles(
      {this.id,
      this.name,
      this.guardName,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  String modelId;
  String roleId;
  String modelType;

  Pivot({this.modelId, this.roleId, this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    data['model_type'] = this.modelType;
    return data;
  }
}

class Driver {
  String userId;
  String gender;
  String wallet;
  String idCardImagePath;
  String formImgPath;
  String licenseImgPath;
  String frontImgPath;
  String backImgPath;

  Driver(
      {this.userId,
      this.gender,
      this.wallet,
      this.idCardImagePath,
      this.formImgPath,
      this.licenseImgPath,
      this.frontImgPath,
      this.backImgPath});

  Driver.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    gender = json['gender'];
    wallet = json['wallet'];
    idCardImagePath = json['id_card_image_path'];
    formImgPath = json['form_img_path'];
    licenseImgPath = json['license_img_path'];
    frontImgPath = json['front_img_path'];
    backImgPath = json['back_img_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['gender'] = this.gender;
    data['wallet'] = this.wallet;
    data['id_card_image_path'] = this.idCardImagePath;
    data['form_img_path'] = this.formImgPath;
    data['license_img_path'] = this.licenseImgPath;
    data['front_img_path'] = this.frontImgPath;
    data['back_img_path'] = this.backImgPath;
    return data;
  }
}
