import 'package:tcord/main.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/views/animation/fade_animation.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/login/forgotPassword.dart';
import 'package:tcord/views/login/signup.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginPageController controller = Get.put(LoginPageController(context));
    final node = FocusScope.of(context);
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/png/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 50,
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.width - 100,
                        child: FadeAnimation(
                            1,
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        colorFilter:
                                            ColorFilter.linearToSrgbGamma(),
                                        image: AssetImage(
                                            'assets/png/mic-1.png'))),
                              ),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.3,
                            Container(
                              child: Center(
                                child: Text(
                                  "T-cord",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            2,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.linearToSrgbGamma(),
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage('assets/png/lines.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            2.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/1.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            2.6,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/2.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            2.9,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/3.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            3.1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/4.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            3.4,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/5.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            3.7,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/6.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            4,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/7.png'))),
                            )),
                      ),
                      Positioned(
                        top: 15,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: FadeAnimation(
                            4.2,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter:
                                          ColorFilter.srgbToLinearGamma(),
                                      image: AssetImage('assets/png/8.png'))),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                                      AppLocalizations.of(context)!.userName,
                                      controller.userNameController,
                                      controller.userNameFocusNode,
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
                                      onEditingComplete: () =>
                                          controller.onLogin(context),
                                      textInputAction: TextInputAction.go),
                                ),
                              ],
                            ),
                          )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FadeAnimation(
                            1.5,
                            InkWell(
                              onTap: () => Get.to(() => ForgotPasswordPage()),
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: TextStyle(
                                    color: AppTheme.Lilac,
                                    fontSize: AppTheme.CaptionFontSize11),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FadeAnimation(
                          2,
                          InkWell(
                            onTap: () => controller.onLogin(context),
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
                                  AppLocalizations.of(context)!.login,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppTheme.Body2FontSize18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 60,
                      ),
                      FadeAnimation(
                          2,
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                      color: AppTheme.GrayWeb,
                                      fontSize: AppTheme.FootnoteFontSize13),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                    onTap: () => Get.to(() => SignupPage()),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.signup,
                                        style: TextStyle(
                                            color: AppTheme.Opal,
                                            fontSize: AppTheme.Body2FontSize18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                              ],
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

class LoginPageController extends BaseGetxController {
  late AuthenticationService _authenticationService;
  var isLoginEnabled = false.obs;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  LoginPageController(BuildContext context) : super(context) {
    _authenticationService = Get.find();
    userNameController.addListener(textChanged);
    passwordController.addListener(textChanged);
  }

  focusPassword() {
    passwordFocusNode.requestFocus();
  }

  textChanged() {
    isLoginEnabled.value = userNameController.text.isNotEmpty &&
        passwordController.value.text.isNotEmpty;
  }

  onLogin(BuildContext context) async {
    if (!isLoginEnabled.value) return;
    if (userNameFocusNode.hasFocus) userNameFocusNode.unfocus();
    if (passwordFocusNode.hasFocus) passwordFocusNode.unfocus();
    isBusy.value = true;

    var response = await _authenticationService.authenticate(
        userNameController.text, passwordController.text);
    isBusy.value = false;
    if (response != null) {
      await authenticationService.setUserAuthenticated();
      await Get.offAll(() => MainPage(), transition: Transition.noTransition);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
