import 'package:get/get.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/developer_service.dart';
import 'package:tcord/services/service_base.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tcord/utils/constants.dart';

class UserService extends ServiceBase {
  final String lastViewedUsersStorageKey = "last_viewed_user_storage";
  final List<Function> _lastViewedUsersListeners = <Function>[];

  Future<UserModel> getUser(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/user/$id');

      var encodedResponse = UserResponse.fromJson(jsonDecode(response!));
      if (encodedResponse.user != null &&
          encodedResponse.user!.id !=
              authenticationService.authenticationData?.user?.id) {
        var lastViewedUsers = await getLastViewedUsers();
        var userInCache = lastViewedUsers.firstWhere(
            (element) => element.id == encodedResponse.user!.id,
            orElse: () => UserModel());
        if (userInCache.id == null) {
          lastViewedUsers.insert(0, encodedResponse.user!);
          _setLastViewedUsers(lastViewedUsers);
        }
      }
      return encodedResponse.user!;
    } catch (e) {
      return UserModel();
    }
  }

  Future<UserModel?> editProfile(UserModel user) async {
    try {
      final response = await apiService.put(Constants.serverUrl, 'api/user',
          body: jsonEncode(user.toJson()));
      var encodedResponse = UserModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> updateFCM(UserModel user) async {
    try {
      final response = await apiService.put(Constants.serverUrl, 'api/user',
          body: jsonEncode(user.toJson()));
      var encodedResponse = UserModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> follow(FollowRequest user) async {
    try {
      final response = await apiService.put(Constants.serverUrl, 'api/follow',
          body: jsonEncode(user.toJson()));
      var encodedResponse = UserModel.fromJson(jsonDecode(response!));
      return encodedResponse;
    } catch (e) {
      return null;
    }
  }

  Future<CompositionsResponse> getUserCompositions(String id) async {
    try {
      final response = await apiService.get(
          Constants.serverUrl, 'api/user/$id/compositions');
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

  Future<CompositionsResponse> getUserDebuts(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/user/$id/debuts');
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

  Future<CompositionsResponse> getUserLikes(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/user/$id/liked');
      var encodedResponse =
          CompositionsResponse.fromJson(jsonDecode(response!));
      encodedResponse.compositions!.forEach((element) {
        element.isLiked = true;
      });
      return encodedResponse;
    } catch (e) {
      return CompositionsResponse();
    }
  }

  Future<List<UserModel>?> getUserFollowing(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/user/$id/following');
      var encodedResponse = UserSearchResponse.fromJson(jsonDecode(response!));
      return encodedResponse.users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserModel>?> getUserFollowers(String id) async {
    try {
      final response =
          await apiService.get(Constants.serverUrl, 'api/user/$id/followers');
      var encodedResponse = UserSearchResponse.fromJson(jsonDecode(response!));
      return encodedResponse.users;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserModel>?> searchUser(
      String text, int pageNumber, int pageLimit) async {
    try {
      var parameters = Map<String, dynamic>();
      parameters['search'] = text;
      parameters['pageNumber'] = pageNumber.toString();
      parameters['pageLimit'] = pageLimit.toString();
      final response = await apiService.get(Constants.serverUrl, 'api/user',
          parameters: parameters);
      var encodedResponse = UserSearchResponse.fromJson(jsonDecode(response!));
      return encodedResponse.users;
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>> getLastViewedUsers() async {
    var users = storageBox.read(lastViewedUsersStorageKey);
    if (users != null && users is List<UserModel>) {
      return users;
    } else {
      return <UserModel>[];
    }
  }

  Future<bool> deleteUser() async {
    try {
      await apiService.delete(Constants.serverUrl, 'api/user');

      return true;
    } catch (e) {
      return false;
    }
  }

  void addLastViewedUsersListener(Function listener) {
    _lastViewedUsersListeners.add(listener);
  }

  void removeLastViewedUsersListener(Function listener) {
    _lastViewedUsersListeners.add(listener);
  }

  Future _setLastViewedUsers(List<UserModel> users) async {
    _lastViewedUsersListeners.forEach((element) {
      try {
        element(users);
      } catch (e) {}
    });
    storageBox.write(lastViewedUsersStorageKey, users);
  }
}
