import 'package:tcord/main.dart';
import 'package:tcord/models/authentication/signup_request.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/views/animation/fade_animation.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResetPasswordPageController controller =
        Get.put(ResetPasswordPageController(context));
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/png/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 21, bottom: 7.5),
                                  child: CustomInputForm(
                                      "Code",
                                      controller.codeController,
                                      controller.codeFocusNode,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7.5, bottom: 7.5),
                                  child: CustomInputForm(
                                      AppLocalizations.of(context)!.password,
                                      controller.passwordController,
                                      controller.passwordFocusNode,
                                      isPassword: true,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7.5, bottom: 35),
                                  child: CustomInputForm(
                                      AppLocalizations.of(context)!
                                          .verifyPassword,
                                      controller.password2Controller,
                                      controller.password2FocusNode,
                                      isPassword: true,
                                      onEditingComplete: () =>
                                          controller.onResetPassword(context),
                                      textInputAction: TextInputAction.go),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2,
                          InkWell(
                            onTap: () => controller.onResetPassword(context),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    AppTheme.Lilac,
                                    AppTheme.Opal,
                                  ])),
                              child: Center(
                                child: Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: controller.isBusy.value,
              child: BusyPageIndicator(),
            ))
      ]),
    );
  }
}

class ResetPasswordPageController extends BaseGetxController {
  late AuthenticationService _authenticationService;
  var isSignupEnabled = false.obs;
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  final codeFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final password2FocusNode = FocusNode();

  ResetPasswordPageController(BuildContext context) : super(context) {
    _authenticationService = Get.find();
    codeController.addListener(textChanged);
    passwordController.addListener(textChanged);
    password2Controller.addListener(textChanged);
  }

  textChanged() {
    isSignupEnabled.value = codeController.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty &&
        password2Controller.value.text.isNotEmpty;
  }

  onResetPassword(BuildContext context) async {
    if (!isSignupEnabled.value) return;
    if (codeFocusNode.hasFocus) codeFocusNode.unfocus();
    if (passwordFocusNode.hasFocus) passwordFocusNode.unfocus();
    if (password2FocusNode.hasFocus) password2FocusNode.unfocus();

    if (passwordController.text != password2Controller.text) {
      await showCustomGeneralDialog(
          context,
          Icon(
            Icons.error_outline,
            size: 57,
            color: AppTheme.Critical,
          ),
          AppLocalizations.of(context)!.passworDoesntMatch,
          AppLocalizations.of(context)!.okayUpper);
      return;
    }
    isBusy.value = true;

    var request = new SignupRequest(password: passwordController.text);
    var response = await _authenticationService.resetPassword(
        request, codeController.text);
    isBusy.value = false;
    if (response != null) {
      Get.back();
      await showCustomGeneralDialog(
          context,
          Icon(
            Icons.check_circle,
            size: 100,
            color: AppTheme.Success,
          ),
          response,
          AppLocalizations.of(context)!.okayUpper);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
