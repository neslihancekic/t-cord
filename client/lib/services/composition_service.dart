import 'package:get/get.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/models/upload/UploadResponse.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/service_base.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tcord/utils/constants.dart';

class CompositionService extends ServiceBase {
  Future<TrackModel> createTrack(TrackModel request) async {
    try {
      var body = jsonEncode(request.toJson());
      final response =
          await apiService.post(Constants.serverUrl, 'api/track', body: body);
      var encodedResponse = TrackModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return TrackModel();
    }
  }

  Future<CompositionModel> createComposition(CompositionModel request) async {
    try {
      var body = jsonEncode(request.toJson());
      final response = await apiService
          .post(Constants.serverUrl, 'api/composition', body: body);
      var encodedResponse = CompositionModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return CompositionModel();
    }
  }

  Future<TrackModel> updateTrackMidi(String csvFile, String trackId) async {
    try {
      var body = jsonEncode({"csv": csvFile});
      final response = await apiService
          .put(Constants.serverUrl, 'api/track/csvToMidi/$trackId', body: body);
      var encodedResponse = TrackModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return TrackModel();
    }
  }

  Future<CompositionsResponse> allCompositions() async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/compositions');
      var encodedResponse =
          CompositionsResponse.fromJson(jsonDecode(response!));
      encodedResponse.compositions!.forEach((element) {
        element.isLiked = element.likes!
            .contains(authenticationService.authenticationData!.user!.id!);
      });
      return encodedResponse;
    } catch (e) {
      return CompositionsResponse();
    }
  }

  Future<CompositionModel> likeComposition(String compositionId) async {
    try {
      final response =
          await apiService.put(Constants.serverUrl, 'api/like/$compositionId');
      var encodedResponse = CompositionModel.fromJson(jsonDecode(response!));
      encodedResponse.isLiked = encodedResponse.likes!
          .contains(authenticationService.authenticationData!.user!.id!);
      return encodedResponse;
    } catch (e) {
      return CompositionModel();
    }
  }

  Future<CompositionModel> addTrack(
      TrackModel request, String compositionId) async {
    try {
      var body = jsonEncode(request.toJson());
      final response = await apiService
          .post(Constants.serverUrl, 'api/addTrack/$compositionId', body: body);
      var encodedResponse = CompositionModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return CompositionModel();
    }
  }

  Future<bool> deleteComposition(String compositionId) async {
    try {
      await apiService.delete(
          Constants.serverUrl, 'api/composition/$compositionId');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>?> getContributers(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/contributers/$id');
      var encodedResponse = UserSearchResponse.fromJson(jsonDecode(response!));
      return encodedResponse.users;
    } catch (e) {
      return null;
    }
  }
}
