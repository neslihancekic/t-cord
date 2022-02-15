import 'dart:convert';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:get/get.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/network/monitoring_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class ApiService {
  final AuthenticationService _authenticationService = Get.find();
  final DeveloperService _developerService = Get.put(DeveloperService());
  final MonitoringService _monitoringService = Get.put(MonitoringService());
  Future<String?> get(String baseUrl, String path,
      {Map<String, dynamic>? parameters}) async {
    var responseJson;
    try {
      final response = await _monitoringService.send(
          HttpMethod.Get, baseUrl, path, _authenticationService.headers,
          parameters: parameters);
      await _developerService.saveOperation(
          operationType: "GET",
          baseUrl: Uri.https(baseUrl, path, parameters),
          requestHeaders: jsonEncode(_authenticationService.headers),
          responseJson: response!.body);
      responseJson = _response(response);
    } on Exception catch (e) {
      print("xxx" + e.toString());
      return null;
    }
    return responseJson;
  }

  Future<String?> post(String baseUrl, String path,
      {Map<String, dynamic>? parameters, String? body}) async {
    var responseJson;
    try {
      final response = await _monitoringService.send(
          HttpMethod.Post, baseUrl, path, _authenticationService.headers,
          parameters: parameters, body: body);
      await _developerService.saveOperation(
          operationType: "POST",
          baseUrl: Uri.https(baseUrl, path, parameters),
          requestHeaders: jsonEncode(_authenticationService.headers),
          responseJson: response!.body,
          requestJson: body ?? "");
      responseJson = _response(response);
    } on Exception catch (e) {
      print("xxx" + e.toString());
      return null;
    }
    return responseJson;
  }

  Future<String?> put(String baseUrl, String path,
      {Map<String, dynamic>? parameters, String? body}) async {
    var responseJson;
    try {
      final response = await _monitoringService.send(
          HttpMethod.Put, baseUrl, path, _authenticationService.headers,
          parameters: parameters, body: body);
      await _developerService.saveOperation(
          operationType: "PUT",
          baseUrl: Uri.https(baseUrl, path, parameters),
          requestHeaders: jsonEncode(_authenticationService.headers),
          responseJson: response!.body,
          requestJson: body ?? "");
      responseJson = _response(response);
    } on Exception catch (e) {
      print("xxx" + e.toString());
      return null;
    }
    return responseJson;
  }

  Future<String?> delete(String baseUrl, String path,
      {Map<String, dynamic>? parameters}) async {
    var responseJson;
    try {
      final response = await _monitoringService.send(
          HttpMethod.Delete, baseUrl, path, _authenticationService.headers,
          parameters: parameters);
      await _developerService.saveOperation(
          operationType: "DELETE",
          baseUrl: Uri.https(baseUrl, path, parameters),
          requestHeaders: jsonEncode(_authenticationService.headers),
          responseJson: response!.body);
      responseJson = _response(response);
    } on Exception catch (e) {
      print("xxx" + e.toString());
      return null;
    }
    return responseJson;
  }

  String _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        return response.body;
      case 401:
        return response.body;
      case 403:
        return response.body;
      case 500:
        return response.body;
      default:
        return response.body;
    }
  }
}
