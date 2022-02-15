import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tcord/models/upload/UploadResponse.dart';
import 'package:tcord/services/service_base.dart';
import 'package:tcord/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class UploadService extends ServiceBase {
  Future<UploadResponse?> transcribe(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'flutter_sound.wav',
          contentType: new MediaType("audio", "wav"),
        )
      });

      print(Uri.https(Constants.serverUrl, "transcribe").toString());
      var response = await dio.post(
          Uri.https(Constants.serverUrl, "transcribe").toString(),
          data: formData);
      var data = UploadResponse.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> downloadFile(String url) async {
    try {
      var dio = Dio();
      print(url);
      var response = await dio.get(url);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<List<int>?> downloadSound(String url) async {
    try {
      var dio = Dio();
      print(url);
      var response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> postCsv(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(File(filePath).readAsBytesSync(),
            filename: filePath.split("/").last)
      });

      print(Uri.https(Constants.serverUrl, "csv/upload").toString());
      var response;
      try {
        response = await dio.post(
            Uri.https(Constants.serverUrl, "csv/upload").toString(),
            data: formData);
      } on DioError catch (e) {
        throw Exception(e.response?.data);
      }

      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> postWav(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'flutter_sound.wav',
          contentType: new MediaType("audio", "wav"),
        )
      });
      print(Uri.https(Constants.serverUrl, "wav/upload").toString());
      var response;
      try {
        response = await dio.post(
            Uri.https(Constants.serverUrl, "wav/upload").toString(),
            data: formData);
      } on DioError catch (e) {
        throw Exception(e.response?.data);
      }

      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> postImg(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: 'profile.jpeg',
          contentType: new MediaType("image", "jpeg"),
        )
      });
      print(Uri.https(Constants.serverUrl, "image/upload").toString());
      var response;
      try {
        response = await dio.post(
            Uri.https(Constants.serverUrl, "image/upload").toString(),
            data: formData);
      } on DioError catch (e) {
        throw Exception(e.response?.data);
      }

      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<UploadResponse?> csvToMidi(String filePath) async {
    try {
      var dio = Dio();
      var formData = FormData.fromMap({
        'csv': await MultipartFile.fromFile(
          filePath,
          filename: 'flutter_sound.wav',
          contentType: new MediaType("audio", "wav"),
        )
      });

      print(Uri.https(Constants.serverUrl, "wav/upload").toString());
      var response = await dio.post(
          Uri.https(Constants.serverUrl, "wav/upload").toString(),
          data: formData);
      var data = UploadResponse.fromJson(response.data);
      return data;
    } catch (e) {
      print(e);
    }
  }
}
