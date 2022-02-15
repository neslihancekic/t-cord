import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcord/models/authentication/authentication_data.dart';
import 'package:tcord/models/authentication/signup_request.dart';
import 'package:tcord/models/user/login_request.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/network/monitoring_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/utils/constants.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:tcord/views/home/home.dart';

class AuthenticationService {
  //final DeveloperService _developerService = Get.put(DeveloperService());
  final MonitoringService _monitoringService = Get.put(MonitoringService());
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  AuthenticationData? authenticationData;

  Map<String, String> get headers {
    return _headers ??
        <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        };
  }

  Future<UserModel?> authenticate(String userName, String password) async {
    final LoginRequest loginRequest = LoginRequest();
    loginRequest.username = userName;
    loginRequest.password = password;
    var response;
    try {
      response = await _monitoringService.send(
          HttpMethod.Post, Constants.serverUrl, '/api/signin', headers,
          body: jsonEncode(loginRequest.toJson()));
      authenticationData =
          AuthenticationData.fromJson(jsonDecode(response.body));
      await initializeApiHeaders();
      await setUserAuthenticated();
      var messaging = FirebaseMessaging.instance;
      UserService _userService = Get.find();
      messaging.getToken().then((value) {
        _userService.updateFCM(UserModel(fcmToken: value));
      });
    } catch (e) {
      return null;
    }

    return authenticationData!.user;
  }

  Future<UserModel?> signup(SignupRequest request) async {
    var data;
    try {
      final response = await _monitoringService.send(
          HttpMethod.Post, Constants.serverUrl, '/api/signup', headers,
          body: jsonEncode(request.toJson()));
      data = UserModel.fromJson(jsonDecode(response!.body));
    } catch (e) {
      return null;
    }
    return data;
  }

  Future<String?> recoverPassword(SignupRequest request) async {
    try {
      final response = await _monitoringService.send(
          HttpMethod.Post, Constants.serverUrl, '/api/recover', headers,
          body: jsonEncode(request.toJson()));
      if (response!.statusCode != 200) {
        throw Exception();
      }
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<String?> resetPassword(SignupRequest request, String code) async {
    try {
      final response = await _monitoringService.send(HttpMethod.Post,
          Constants.serverUrl, '/api/resetPassword/$code', headers,
          body: jsonEncode(request.toJson()));
      if (response!.statusCode != 200) {
        throw Exception();
      }
      return jsonDecode(response.body);
    } catch (e) {
      return "";
    }
  }

  Map<String, String>? _headers;
  Future setUserAuthenticated() async {
    await storage.write(
        key: Constants.AuthenticationDataKey,
        value: jsonEncode(authenticationData!.toJson()));
    return true;
  }

  Future initializeApiHeaders() async {
    _headers = Map<String, String>();
    _headers!["Content-Type"] = "application/json; charset=UTF-8";
    _headers!["Charset"] = "utf-8";
    _headers!["UserId"] = authenticationData!.user!.id!;
    _headers![HttpHeaders.authorizationHeader] =
        'Bearer ' + (authenticationData!.token ?? "");
  }

  Future<bool> changePassword(String password, {String userName = ""}) async {
    return false;
  }

  Future<bool> forgotPassword({String userName = ""}) async {
    return false;
  }

  Future logout() async {
    await _monitoringService.send(
        HttpMethod.Get, Constants.serverUrl, '/api/signout', headers);
    Get.delete<HomePageController>();
    authenticationData = null;
    await GetStorage().erase();
    storage.delete(key: Constants.AuthenticationDataKey);
  }

  Future init() async {
    await isUserAuthenticated();
  }

  Future<bool> isUserAuthenticated() async {
    if (authenticationData != null) return true;
    String? value = await storage.read(key: Constants.AuthenticationDataKey);
    if (value == null || value.isEmpty) {
      return false;
    } else {
      authenticationData = AuthenticationData.fromJson(jsonDecode(value));
      await initializeApiHeaders();
      return true;
    }
  }

  UserModel get user {
    return authenticationData!.user!;
  }
}
