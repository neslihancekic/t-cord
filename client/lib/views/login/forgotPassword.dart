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
import 'package:tcord/views/login/resetPassword.dart';

// ignore: must_be_immutable
class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ForgotPasswordPageController controller =
        Get.put(ForgotPasswordPageController(context));
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
                                  AppLocalizations.of(context)!.forgotPassword,
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
                    children: [
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7.5, bottom: 7.5),
                                  child: CustomInputForm(
                                      AppLocalizations.of(context)!.email,
                                      controller.emailController,
                                      controller.emailFocusNode,
                                      onEditingComplete: () => node.nextFocus(),
                                      textInputAction: TextInputAction.next),
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
                            onTap: () => controller.onRecover(context),
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
                                  "Send Recovery Code",
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

class ForgotPasswordPageController extends BaseGetxController {
  late AuthenticationService _authenticationService;
  var isResetEnabled = false.obs;
  final emailController = TextEditingController();

  final emailFocusNode = FocusNode();

  final codeController = TextEditingController();

  final codeFocusNode = FocusNode();

  ForgotPasswordPageController(BuildContext context) : super(context) {
    _authenticationService = Get.find();
    emailController.addListener(textChanged);
  }

  textChanged() {
    isResetEnabled.value = emailController.value.text.isNotEmpty;
  }

  onRecover(BuildContext context) async {
    if (!isResetEnabled.value) return;

    if (emailFocusNode.hasFocus) emailFocusNode.unfocus();

    isBusy.value = true;

    var request = new SignupRequest(email: emailController.text);
    var response = await _authenticationService.recoverPassword(request);
    isBusy.value = false;
    if (response != null) {
      Get.back();
      Get.to(() => ResetPasswordPage());
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
