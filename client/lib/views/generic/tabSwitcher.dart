import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';

class TabSwitcher extends StatelessWidget {
  TabSwitcher({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.GrayWeb,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}

class TabSwitcherItem extends StatelessWidget {
  TabSwitcherItem(
      {required this.isSelected, required this.text, required this.onPressed});

  final bool isSelected;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: isSelected ? AppTheme.White : Colors.transparent,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.Opal
                    : AppTheme.DarkJungleGreen.withOpacity(0.3),
                fontSize: AppTheme.BodyFontSize15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
