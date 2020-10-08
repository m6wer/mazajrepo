// class AllorderModel {
//   Orders orders;

//   AllorderModel({this.orders});

//   AllorderModel.fromJson(Map<String, dynamic> json) {
//     orders =
//         json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.orders != null) {
//       data['orders'] = this.orders.toJson();
//     }
//     return data;
//   }
// }

// class Orders {
//   int currentPage;
//   List<Data> data;
//   String firstPageUrl;
//   int from;
//   int lastPage;
//   String lastPageUrl;
//   String nextPageUrl;
//   String path;
//   int perPage;
//   String prevPageUrl;
//   int to;
//   int total;

//   Orders(
//       {this.currentPage,
//       this.data,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total});

//   Orders.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = new List<Data>();
//       json['data'].forEach((v) {
//         data.add(new Data.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

// class Data {
//   int id;
//   String totalPrice;
//   String driverPrice;
//   String status;
//   String note;
//   String userId;
//   String driverId;
//   String deliveryDate;
//   String placeId;
//   String latitudeClient;
//   String longitudeClient;
//   String addressClient;
//   String longitudeDriver;
//   String latitudeDriver;
//   String clientPrice;
//   String leftOver;
//   String createdAt;
//   String updatedAt;
//   List<Products> products;
//   User user;
//   Place place;

//   Data(
//       {this.id,
//       this.totalPrice,
//       this.driverPrice,
//       this.status,
//       this.note,
//       this.userId,
//       this.driverId,
//       this.deliveryDate,
//       this.placeId,
//       this.latitudeClient,
//       this.longitudeClient,
//       this.addressClient,
//       this.longitudeDriver,
//       this.latitudeDriver,
//       this.clientPrice,
//       this.leftOver,
//       this.createdAt,
//       this.updatedAt,
//       this.products,
//       this.user,
//       this.place});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     totalPrice = json['total_price'];
//     driverPrice = json['driver_price'];
//     status = json['status'];
//     note = json['note'];
//     userId = json['user_id'];
//     driverId = json['driver_id'];
//     deliveryDate = json['delivery_date'];
//     placeId = json['place_id'];
//     latitudeClient = json['latitude_client'];
//     longitudeClient = json['longitude_client'];
//     addressClient = json['address_client'];
//     longitudeDriver = json['longitude_driver'];
//     latitudeDriver = json['latitude_driver'];
//     clientPrice = json['client_price'];
//     leftOver = json['left_over'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['products'] != null) {
//       products = new List<Products>();
//       json['products'].forEach((v) {
//         products.add(new Products.fromJson(v));
//       });
//     }
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     place = json['place'] != null ? new Place.fromJson(json['place']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['total_price'] = this.totalPrice;
//     data['driver_price'] = this.driverPrice;
//     data['status'] = this.status;
//     data['note'] = this.note;
//     data['user_id'] = this.userId;
//     data['driver_id'] = this.driverId;
//     data['delivery_date'] = this.deliveryDate;
//     data['place_id'] = this.placeId;
//     data['latitude_client'] = this.latitudeClient;
//     data['longitude_client'] = this.longitudeClient;
//     data['address_client'] = this.addressClient;
//     data['longitude_driver'] = this.longitudeDriver;
//     data['latitude_driver'] = this.latitudeDriver;
//     data['client_price'] = this.clientPrice;
//     data['left_over'] = this.leftOver;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.products != null) {
//       data['products'] = this.products.map((v) => v.toJson()).toList();
//     }
//     if (this.user != null) {
//       data['user'] = this.user.toJson();
//     }
//     if (this.place != null) {
//       data['place'] = this.place.toJson();
//     }
//     return data;
//   }
// }

// class Products {
//   int id;
//   String name;
//   String quantity;
//   String image;
//   String note;
//   String orderId;

//   Products(
//       {this.id, this.name, this.quantity, this.image, this.note, this.orderId});

//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     quantity = json['quantity'];
//     image = json['image'];
//     note = json['note'];
//     orderId = json['order_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['quantity'] = this.quantity;
//     data['image'] = this.image;
//     data['note'] = this.note;
//     data['order_id'] = this.orderId;
//     return data;
//   }
// }

// class User {
//   int id;
//   String name;
//   String email;
//   String emailVerifiedAt;
//   String image;
//   String phone;
//   String mobileToken;
//   String createdAt;
//   String updatedAt;
//   String code;
//   String imagePath;

//   User(
//       {this.id,
//       this.name,
//       this.email,
//       this.emailVerifiedAt,
//       this.image,
//       this.phone,
//       this.mobileToken,
//       this.createdAt,
//       this.updatedAt,
//       this.code,
//       this.imagePath});

//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     emailVerifiedAt = json['email_verified_at'];
//     image = json['image'];
//     phone = json['phone'];
//     mobileToken = json['mobile_token'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     code = json['code'];
//     imagePath = json['image_path'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['email_verified_at'] = this.emailVerifiedAt;
//     data['image'] = this.image;
//     data['phone'] = this.phone;
//     data['mobile_token'] = this.mobileToken;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['code'] = this.code;
//     data['image_path'] = this.imagePath;
//     return data;
//   }
// }

// class Place {
//   String id;
//   String name;
//   String idPlace;
//   String image;
//   String longitude;
//   String latitude;
//   String address;

//   Place(
//       {this.id,
//       this.name,
//       this.idPlace,
//       this.image,
//       this.longitude,
//       this.latitude,
//       this.address});

//   Place.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     idPlace = json['id_place'];
//     image = json['image'];
//     longitude = json['longitude'];
//     latitude = json['latitude'];
//     address = json['address'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['id_place'] = this.idPlace;
//     data['image'] = this.image;
//     data['longitude'] = this.longitude;
//     data['latitude'] = this.latitude;
//     data['address'] = this.address;
//     return data;
//   }
// }