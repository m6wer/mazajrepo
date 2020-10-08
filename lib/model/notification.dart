class NotificationModel {
  String body;
  String title;
  String day;
  String time;
  String month;
  NotificationModel({this.title, this.body, this.day,this.time, this.month});
  NotificationModel.fromJson(Map<String, dynamic> json)
      : body = json['body'],
        title = json['title'];

  Map<String, dynamic> toJson() => {'body': body, 'title': title};
}
