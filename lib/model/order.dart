class OrderItem {
  int id;
  String userId;
  String placeId;
  String lat;
  String long;
  String address;
  dynamic deliveryCost;
  String total;
  String payment;
  String status;
  String orderDate;
  String deliveryId;
  dynamic comment;
  dynamic rate;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  String service;
  dynamic copoun;
  int deliveryDist;
  int distance;
  Pivot pivot;
  List<Products> products;
  Place place;
  Client client;
  Delivery delivery;

  OrderItem(
      {this.id,
        this.userId,
        this.placeId,
        this.lat,
        this.long,
        this.address,
        this.deliveryCost,
        this.total,
        this.payment,
        this.status,
        this.orderDate,
        this.deliveryId,
        this.comment,
        this.rate,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.service,
        this.copoun,
        this.deliveryDist,
        this.distance,
        this.pivot,
        this.products,
        this.place,
        this.client,
        this.delivery});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    placeId = json['place_id'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    deliveryCost = json['delivery_cost'];
    total = json['total'];
    payment = json['payment'];
    status = json['status'];
    orderDate = json['order_date'];
    deliveryId = json['delivery_id'];
    comment = json['comment'];
    rate = json['rate'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    service = json['service'];
    copoun = json['copoun'];
    deliveryDist = json['delivery_dist'];
    distance = json['distance'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    place = json['place'] != null ? new Place.fromJson(json['place']) : null;
    client =
    json['client'] != null ? new Client.fromJson(json['client']) : null;
    delivery = json['delivery'] != null
        ? new Delivery.fromJson(json['delivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['place_id'] = this.placeId;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['delivery_cost'] = this.deliveryCost;
    data['total'] = this.total;
    data['payment'] = this.payment;
    data['status'] = this.status;
    data['order_date'] = this.orderDate;
    data['delivery_id'] = this.deliveryId;
    data['comment'] = this.comment;
    data['rate'] = this.rate;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['service'] = this.service;
    data['copoun'] = this.copoun;
    data['delivery_dist'] = this.deliveryDist;
    data['distance'] = this.distance;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.place != null) {
      data['place'] = this.place.toJson();
    }
    if (this.client != null) {
      data['client'] = this.client.toJson();
    }
    if (this.delivery != null) {
      data['delivery'] = this.delivery.toJson();
    }
    return data;
  }
}

class Pivot {
  String deliveryId;
  String orderId;

  Pivot({this.deliveryId, this.orderId});

  Pivot.fromJson(Map<String, dynamic> json) {
    deliveryId = json['delivery_id'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_id'] = this.deliveryId;
    data['order_id'] = this.orderId;
    return data;
  }
}

class Products {
  int id;
  String orderId;
  String quantity;
  String name;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  String image;

  Products(
      {this.id,
        this.orderId,
        this.quantity,
        this.name,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.image});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    quantity = json['quantity'];
    name = json['name'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    return data;
  }
}

class Place {
  int id;
  String name;
  String rating;
  String vicinity;
  String image;
  double lat;
  double long;
  String createdAt;
  String updatedAt;

  Place(
      {this.id,
        this.name,
        this.rating,
        this.vicinity,
        this.image,
        this.lat,
        this.long,
        this.createdAt,
        this.updatedAt});

  Place.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    vicinity = json['vicinity'];
    image = json['image'];
    lat = json['lat'];
    long = json['long'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['vicinity'] = this.vicinity;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Client {
  int id;
  String mobile;
  String stcpay;
  String email;
  String gender;
  String code;
  String image;
  dynamic lat;
  dynamic long;
  dynamic address;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  dynamic recieveNotifications;
  String wallet;
  String name;

  Client(
      {this.id,
        this.mobile,
        this.stcpay,
        this.email,
        this.gender,
        this.code,
        this.image,
        this.lat,
        this.long,
        this.address,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.recieveNotifications,
        this.wallet,
        this.name});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    stcpay = json['stcpay'];
    email = json['email'];
    gender = json['gender'];
    code = json['code'];
    image = json['image'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recieveNotifications = json['recieve_notifications'];
    wallet = json['wallet'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['stcpay'] = this.stcpay;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['code'] = this.code;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['recieve_notifications'] = this.recieveNotifications;
    data['wallet'] = this.wallet;
    data['name'] = this.name;
    return data;
  }
}

class Delivery {
  int id;
  String mobile;
  String stcpay;
  String email;
  String gender;
  String code;
  String image;
  String lat;
  String long;
  String address;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;
  dynamic recieveNotifications;
  dynamic wallet;
  String name;

  Delivery(
      {this.id,
        this.mobile,
        this.stcpay,
        this.email,
        this.gender,
        this.code,
        this.image,
        this.lat,
        this.long,
        this.address,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.recieveNotifications,
        this.wallet,
        this.name});

  Delivery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    stcpay = json['stcpay'];
    email = json['email'];
    gender = json['gender'];
    code = json['code'];
    image = json['image'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    recieveNotifications = json['recieve_notifications'];
    wallet = json['wallet'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['stcpay'] = this.stcpay;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['code'] = this.code;
    data['image'] = this.image;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['recieve_notifications'] = this.recieveNotifications;
    data['wallet'] = this.wallet;
    data['name'] = this.name;
    return data;
  }
}
