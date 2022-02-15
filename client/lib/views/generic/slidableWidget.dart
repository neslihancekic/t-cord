import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcord/views/generic/themes.dart';
import 'package:tcord/utils/extensions.dart';

enum SlidableAction { delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;
  final List<SlidableAction> actionList;
  final bool enabled;

  const SlidableWidget({
    required this.child,
    required this.onDismissed,
    required this.actionList,
    required this.enabled,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: child,
      enabled: this.enabled,
      actionExtentRatio: 0.18,

      /// right side
      secondaryActions: addAction(),
    );
  }

  List<Widget> addAction() {
    List<Widget> list = [];
    if (actionList.contains(SlidableAction.delete)) {
      list.add(IconSlideAction(
          caption: 'Delete',
          color: AppTheme.Critical,
          foregroundColor: AppTheme.White,
          iconWidget: Icon(
            Icons.delete,
            color: AppTheme.White,
            size: 15,
          ),
          onTap: () => onDismissed(SlidableAction.delete)));
    }
    return list;
  }
}
