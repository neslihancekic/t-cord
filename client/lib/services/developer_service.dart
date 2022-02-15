import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DeveloperService {
  String dirPath = "";
  Future saveOperation(
      {String? operationType,
      HttpMetric? metric,
      Uri? baseUrl,
      String? requestHeaders,
      String responseJson = "",
      String requestJson = "",
      http.Response? response,
      http.Request? request}) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = baseUrl.toString();
    await FirebaseAnalytics().logEvent(name: operationType!, parameters: data);
    var permissionSatus = await Permission.storage.request();

    if (permissionSatus != PermissionStatus.granted) {
      return;
    }

    var file = "";
    file = file + (operationType + " " + baseUrl.toString() + "\n");
    file = file + ("\n" + "HEADERS" + "\n");
    file = file + ("\n" + requestHeaders! + "\n");
    if (requestJson.isNotEmpty) {
      file = file + ("\n" + "REQUEST" + "\n");
      file = file + ("\n" + requestJson + "\n");
    }
    if (responseJson.isNotEmpty) {
      file = file + ("\n" + "RESPONSE" + "\n");
      file = file + ("\n" + responseJson + "\n");
    }
    List<int> elements = file.codeUnits;
    Uint8List t = Uint8List.fromList(elements);
    MimeType type = MimeType.TEXT;
    dirPath = await FileSaver.instance.saveFile(
        DateFormat('hh_mm_ss').format(DateTime.now()) +
            " " +
            operationType +
            " " +
            baseUrl!.path.replaceAll("/", "_"),
        t,
        "txt",
        mimeType: type);
  }

  Future cleanLogs() async {
    if (dirPath.isNotEmpty) {
      final dir = Directory(dirPath);
      dir.deleteSync(recursive: true);
    }
  }

  Future sendLogs({bool error = false}) async {
    if (dirPath.isEmpty) return;
    final dataDir = Directory(dirPath);
  }
}
