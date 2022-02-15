import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcord/views/generic/themes.dart';

import 'constants.dart';

extension StringExtensions on String {
  String toSvgPath() {
    return "assets/images/$this.svg";
  }
}

extension DateTimeExtensions on DateTime {
  String toApiDateTime() {
    if (this == null) {
      return "";
    }
    return DateFormat(Constants.apiDateTimeFormat).format(this) + "Z";
  }

  String toDeadline() {
    if (this == null) {
      return "-";
    }
    if (this.year == 1 || this.compareTo(DateTime.now()) < 0) {
      return "-";
    } else if (this.difference(DateTime.now()).inDays == 0) {
      if (this.difference(DateTime.now()).inHours == 0) {
        return (this.difference(DateTime.now()).inMinutes).toString() + "m";
      }
      return (this.difference(DateTime.now()).inHours).toString() + "h";
    }
    return (this.difference(DateTime.now()).inDays).toString() + "d";
  }

  Color toDeadlineColor() {
    if (this == null) {
      return AppTheme.DarkJungleGreen.withOpacity(0.3);
    }
    if (this.year == 1 || this.compareTo(DateTime.now()) < 0) {
      return AppTheme.DarkJungleGreen.withOpacity(0.3);
    } else if (this.difference(DateTime.now()).inDays == 0) {
      if (this.difference(DateTime.now()).inHours == 0) {
        return AppTheme.Critical;
      }
      return AppTheme.Lilac;
    }
    return AppTheme.DarkJungleGreen;
  }
}
