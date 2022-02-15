import 'package:get/get.dart';
import 'package:tcord/models/comment/comment_model.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/service_base.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tcord/utils/constants.dart';

class CommentService extends ServiceBase {
  Future<CommentModel> createComment(CommentModel request) async {
    try {
      var body = jsonEncode(request.toJson());
      final response = await apiService
          .post(Constants.serverUrl, 'api/comment/', body: body);
      var encodedResponse = CommentModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return CommentModel();
    }
  }

  Future<List<CommentModel>?> getComments(String compositionId) async {
    try {
      final response = await apiService.get(
          Constants.serverUrl, 'api/comments/$compositionId');
      var encodedResponse = CommentsResponse.fromJson(jsonDecode(response!));
      return encodedResponse.comments!;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    try {
      await apiService.delete(Constants.serverUrl, 'api/comment/$commentId');

      return true;
    } catch (e) {
      return false;
    }
  }
}
