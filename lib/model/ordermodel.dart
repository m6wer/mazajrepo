class OrderModel {
  Orders orders;

  OrderModel({this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orders =
        json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders.toJson();
    }
    return data;
  }
}

class Orders {
  int currentPage;
  List<Data> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  Orders(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Orders.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String id;
  String name;
  String driverPrice;
  String typePayment;
  String phone;
  String address;
  String neighborhoodId;
  String driverId;
  String status;
  String note;
  String totalPrice;
  String transactionNo;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  List<Products> products;

  Data(
      {this.id,
      this.name,
      this.phone,
      this.address,
      this.driverPrice,
      this.neighborhoodId,
      this.driverId,
      this.typePayment,
      this.status,
      this.note,
      this.totalPrice,
      this.transactionNo,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.products});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverPrice = json['driver_price'];
    name = json['name'];
    typePayment = json['type_payment'];
    phone = json['phone'];
    address = json['address'];
    neighborhoodId = json['neighborhood_id'];
    driverId = json['driver_id'];
    status = json['status'];
    note = json['note'];
    totalPrice = json['total_price'];
    transactionNo = json['transactionNo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['driver_price'] = this.driverPrice;
    data['address'] = this.address;
    data['type_payment'] = this.typePayment;
    data['neighborhood_id'] = this.neighborhoodId;
    data['driver_id'] = this.driverId;
    data['status'] = this.status;
    data['note'] = this.note;
    data['total_price'] = this.totalPrice;
    data['transactionNo'] = this.transactionNo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String id;
  String nameAr;
  String nameEn;
  String descriptionEn;
  String descriptionAr;
  String categoryId;
  String salePrice;
  String colors;
  String stock;
  String weight;
  String image;
  String createdAt;
  String updatedAt;
  String imagePath;
  String name;
  String description;
  Pivot pivot;

  Products(
      {this.id,
      this.nameAr,
      this.nameEn,
      this.descriptionEn,
      this.descriptionAr,
      this.categoryId,
      this.salePrice,
      this.colors,
      this.stock,
      this.weight,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.imagePath,
      this.name,
      this.description,
      this.pivot});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    categoryId = json['category_id'];
    salePrice = json['sale_price'];
    colors = json['colors'].cast<String>();
    stock = json['stock'];
    weight = json['weight'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['image_path'];
    name = json['name'];
    description = json['description'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['description_en'] = this.descriptionEn;
    data['description_ar'] = this.descriptionAr;
    data['category_id'] = this.categoryId;
    data['sale_price'] = this.salePrice;
    data['colors'] = this.colors;
    data['stock'] = this.stock;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_path'] = this.imagePath;
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  String orderId;
  String productId;
  String quantity;
  String color;

  Pivot({this.orderId, this.productId, this.quantity, this.color});

  Pivot.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['color'] = this.color;
    return data;
  }
}
