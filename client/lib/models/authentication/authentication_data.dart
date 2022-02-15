import 'package:tcord/models/base_model.dart';
import 'package:tcord/models/user/user_model.dart';

class AuthenticationData extends BaseModel {
  String? token;
  UserModel? user;
  AuthenticationData(this.token, this.user);

  AuthenticationData.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user'] = this.user!.toJson();
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    token = json['token'];
    user = json['user'] == null ? null : UserModel.fromJson(json['user']);
  }
}
