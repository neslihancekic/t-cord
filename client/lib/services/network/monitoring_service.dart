import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tcord/models/generic/error.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/themes.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonitoringService {
  Future<http.Response?> send(HttpMethod method, String baseUrl, String path,
      Map<String, String> headers,
      {Map<String, dynamic>? parameters, String? body}) async {
    http.Response? response;
    Uri uri = Uri.https(baseUrl, path, parameters);
    /*
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(uri.toString(), method);
    await metric.start();
    */
    switch (method) {
      case HttpMethod.Get:
        response = await http.get(Uri.https(baseUrl, path, parameters),
            headers: headers);
        break;
      case HttpMethod.Post:
        response = await http.post(Uri.https(baseUrl, path, parameters),
            headers: headers, body: body);
        break;
      case HttpMethod.Put:
        response = await http.put(Uri.https(baseUrl, path, parameters),
            headers: headers, body: body);
        break;
      case HttpMethod.Delete:
        response = await http.delete(Uri.https(baseUrl, path, parameters),
            headers: headers);
        break;
      default:
        break;
    }
    /*try {
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = response.request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }
    */

    if (response!.statusCode >= 400) {
      var resp = ErrorModel.fromJson(jsonDecode(response.body));
      BuildContext context = Get.context!;
      print(Get.currentRoute);
      await showCustomGeneralDialog(
          context,
          Icon(
            Icons.error_outline,
            size: 100,
            color: AppTheme.Critical,
          ),
          resp.messages!,
          AppLocalizations.of(context)!.okayUpper);
      throw Exception(response);
    }
    return response;
  }
}
