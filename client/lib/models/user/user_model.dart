class UserModel {
  String? id;
  String? fcmToken;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? username;
  String? profilePhoto;
  String? profileInfo;
  List<String>? followers;
  List<String>? following;
  List<String>? compositions;
  List<String>? debutCompositions;
  List<String>? likedCompositions;
  int? followerCount;
  int? followingCount;
  int? compositionCount;
  int? likedCompositionCount;
  int? debutCompositionCount;
  bool? isFollowing;

  UserModel(
      {this.id,
      this.fcmToken,
      this.firstName,
      this.lastName,
      this.email,
      this.username,
      this.profileInfo,
      this.profilePhoto});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fcmToken = json['fcmToken'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    username = json['username'];
    profilePhoto = json['profilePhoto'];
    profileInfo = json['profileInfo'];
    followers = json['followers']?.cast<String>();
    following = json['following']?.cast<String>();
    likedCompositions = json['compositions']?.cast<String>();
    likedCompositions = json['likedCompositions']?.cast<String>();
    likedCompositions = json['debutCompositions']?.cast<String>();
    followerCount = json['followerCount'];
    followingCount = json['followingCount'];
    compositionCount = json['compositionCount'];
    likedCompositionCount = json['likedCompositionCount'];
    debutCompositionCount = json['debutCompositionCount'];
    isFollowing = json['isFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['fcmToken'] = this.fcmToken;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['profileInfo'] = this.profileInfo;
    data['profilePhoto'] = this.profilePhoto;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['compositions'] = this.compositions;
    data['likedCompositions'] = this.likedCompositions;
    data['debutCompositions'] = this.debutCompositions;
    data['followerCount'] = this.followerCount;
    data['followingCount'] = this.followingCount;
    data['compositionCount'] = this.compositionCount;
    data['likedCompositionCount'] = this.likedCompositionCount;
    data['debutCompositionCount'] = this.debutCompositionCount;
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}

class UserResponse {
  UserModel? user;

  UserResponse.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : UserModel.fromJson(json["user"]);
  }
}

class UserSearchResponse {
  List<UserModel>? users;

  UserSearchResponse({this.users});

  UserSearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<UserModel>.empty(growable: true);
      json['users'].forEach((v) {
        users!.add(new UserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowRequest {
  String? userId;

  FollowRequest({this.userId});

  FollowRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}
