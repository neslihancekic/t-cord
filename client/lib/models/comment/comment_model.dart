class CommentsResponse {
  List<CommentModel>? comments;

  CommentsResponse({this.comments});

  CommentsResponse.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = <CommentModel>[];
      json['comments'].forEach((v) {
        comments!.add(new CommentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentModel {
  String? sId;
  String? userId;
  String? commentedUserId;
  String? compositionId;
  String? comment;
  String? photo;
  String? username;
  String? createdAt;
  String? updatedAt;

  CommentModel(
      {this.sId,
      this.userId,
      this.commentedUserId,
      this.compositionId,
      this.comment,
      this.photo,
      this.username,
      this.createdAt,
      this.updatedAt});

  CommentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    commentedUserId = json['commentedUserId'];
    compositionId = json['compositionId'];
    comment = json['comment'];
    photo = json['photo'];
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['commentedUserId'] = this.commentedUserId;
    data['compositionId'] = this.compositionId;
    data['comment'] = this.comment;
    data['photo'] = this.photo;
    data['username'] = this.username;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}
