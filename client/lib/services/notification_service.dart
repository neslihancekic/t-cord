import 'package:get/get.dart';
import 'package:tcord/models/notification/notification_model.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/service_base.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tcord/utils/constants.dart';

class NotificationService extends ServiceBase {
  Future<List<NotificationModel>?> getNotifications() async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/notifications');
      var encodedResponse =
          NotificationsResponse.fromJson(jsonDecode(response!));
      return encodedResponse.notifications!;
    } catch (e) {
      return null;
    }
  }

  Future<NotificationModel?> readNotification(
      String id, NotificationModel request) async {
    try {
      final response = await apiService.put(
          Constants.serverUrl, 'api/notification/$id/isRead',
          body: jsonEncode(request.toJson()));
      var encodedResponse = NotificationModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    try {
      await apiService.delete(
          Constants.serverUrl, 'api/notification/$notificationId');

      return true;
    } catch (e) {
      return false;
    }
  }
}
