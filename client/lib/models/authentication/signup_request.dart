class SignupRequest {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;

  SignupRequest(
      {this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.password});

  SignupRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data.removeWhere((key, value) => key == null || value == null);
    return data;
  }
}
