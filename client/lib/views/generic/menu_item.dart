import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tcord/utils/extensions.dart';
import 'package:tcord/views/generic/themes.dart';

Widget buildMenuItem(
    Color iconBackgroundColor, SvgPicture iconData, String text,
    {Function? onTap}) {
  return Material(
    child: InkWell(
      onTap: () => {onTap?.call()},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 15, 10),
        child: Row(
          children: [
            Container(
                clipBehavior: Clip.hardEdge,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: iconBackgroundColor,
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                    child: iconData)),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppTheme.BodyFontSize15,
                color: AppTheme.DarkJungleGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            SvgPicture.asset('right'.toSvgPath(),
                color: AppTheme.DarkJungleGreen, width: 24)
          ],
        ),
      ),
    ),
  );
}
