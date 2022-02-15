import 'package:tcord/models/base_model.dart';

class ErrorModel extends BaseModel {
  int? status;
  String? error;
  String? messages;
  ErrorModel(this.error, this.messages, this.status);

  ErrorModel.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['messages'] = this.messages;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    error = json['error'];
    status = json['status'];
    messages = json['messages'];
  }
}
