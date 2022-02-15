class LoginRequest {
  String? username;
  String? password;
  LoginRequest({this.password, this.username});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
