class NotificationsResponse {
  List<NotificationModel>? notifications;

  NotificationsResponse({this.notifications});

  NotificationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <NotificationModel>[];
      json['notifications'].forEach((v) {
        notifications!.add(new NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationModel {
  List<String>? receiverUsersId;
  bool? isRead;
  String? sId;
  String? senderUserId;
  String? compositionId;
  int? type;
  String? title;
  String? body;
  String? image;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.receiverUsersId,
      this.isRead,
      this.sId,
      this.senderUserId,
      this.compositionId,
      this.type,
      this.title,
      this.body,
      this.image,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    receiverUsersId = json['receiverUsersId'].cast<String>();
    isRead = json['isRead'];
    sId = json['_id'];
    senderUserId = json['senderUserId'];
    compositionId = json['compositionId'];
    type = json['type'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiverUsersId'] = this.receiverUsersId;
    data['isRead'] = this.isRead;
    data['_id'] = this.sId;
    data['senderUserId'] = this.senderUserId;
    data['compositionId'] = this.compositionId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}
