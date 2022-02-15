import 'package:flutter_svg/svg.dart';
import 'package:tcord/main.dart';
import 'package:tcord/services/authentication_service.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/generic/actions.dart';
import 'package:tcord/views/generic/base.dart';
import 'package:tcord/views/generic/menu_item.dart';
import 'package:tcord/views/generic/templates.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/views/login/login.dart';

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingsPageController controller =
        Get.put(SettingsPageController(context));
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMenuItem(
                  AppTheme.Lilac.withOpacity(.15),
                  SvgPicture.asset(
                    'logout'.toSvgPath(),
                    color: AppTheme.Lilac,
                    width: 24,
                  ),
                  AppLocalizations.of(context)!.logout, onTap: () async {
                await controller.onLogout();
              })
            ],
          ),
        ),
      ),
    ));
    ;
  }
}

class SettingsPageController extends BaseGetxController {
  SettingsPageController(BuildContext context) : super(context);
  onLogout() async {
    await authenticationService.logout();
    await Get.offAll(() => LoginPage(), transition: Transition.noTransition);
  }
}
