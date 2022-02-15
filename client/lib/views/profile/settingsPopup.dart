import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcord/models/composition/composition_model.dart';
import 'package:tcord/models/user/user_model.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/services/composition_service.dart';
import 'package:tcord/services/upload_service.dart';
import 'package:tcord/services/user_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/edit/edit.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/login/forgotPassword.dart';
import 'package:tcord/views/login/login.dart';

class SettingsPopup extends StatelessWidget {
  const SettingsPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CompositionService _compositionService = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 220,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: AppTheme.GhostWhite,
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        Get.back();
                        Get.to(() => ForgotPasswordPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.password, size: 30, color: AppTheme.Opal),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Edit Password",
                            style: TextStyle(
                                color: AppTheme.DarkJungleGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 11),
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        AuthenticationService authenticationService =
                            Get.find();
                        await authenticationService.logout();
                        await Get.offAll(() => LoginPage(),
                            transition: Transition.noTransition);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.logout_rounded,
                              size: 30, color: AppTheme.MuntbattenPink),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                color: AppTheme.DarkJungleGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 11),
                Container(
                  height: 54,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      boxShadow: [CustomBoxShadow()],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: AppTheme.Critical,
                    child: InkWell(
                      onTap: () async {
                        await showCustomGeneralDialog(
                            context,
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 100,
                              color: AppTheme.Warning,
                            ),
                            "You are about to delete this account",
                            AppLocalizations.of(context)!.okayUpper,
                            okPressed: () async {
                          UserService userService = Get.find();
                          await userService.deleteUser();
                          await Get.offAll(() => LoginPage(),
                              transition: Transition.noTransition);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.delete_forever_rounded,
                              size: 30, color: AppTheme.White),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Delete Account",
                            style: TextStyle(
                                color: AppTheme.White,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            width: 56,
            height: 56,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppTheme.GhostWhite,
                        borderRadius: BorderRadius.circular(22)),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppTheme.Lilac,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
