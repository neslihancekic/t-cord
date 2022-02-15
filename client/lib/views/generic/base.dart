import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseGetxController extends GetxController {
  final BuildContext context;
  final AuthenticationService authenticationService = Get.find();
  BaseGetxController(this.context);
  var isBusy = false.obs;
  var isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics().setCurrentScreen(screenName: Get.currentRoute);
  }
}
