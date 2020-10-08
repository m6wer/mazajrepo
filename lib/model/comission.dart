class ComissionModel {
  List<Orders> orders;

  ComissionModel({this.orders});

  ComissionModel.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String commission;
  String date;
  String year;
  String month;
  String day;

  Orders({this.commission, this.date, this.year, this.month, this.day});

  Orders.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    date = json['date'];
    year = json['year'];
    month = json['month'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['date'] = this.date;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    return data;
  }
}