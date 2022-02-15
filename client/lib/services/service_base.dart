import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/network/api_service.dart';

class ServiceBase {
  final AuthenticationService authenticationService = Get.find();
  final ApiService apiService = Get.find();

  final storageBox = GetStorage();

  Map<String, String> get headers => authenticationService.headers;
}
