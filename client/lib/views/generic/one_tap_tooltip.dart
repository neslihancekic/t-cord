import 'package:tcord/views/generic/themes.dart';
import 'package:flutter/material.dart';

class OneTapToolTip extends StatelessWidget {
  final Widget child;
  final String message;
  final Color textColor;
  final Color? borderColor;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;

  OneTapToolTip(
      {required this.message,
      required this.child,
      this.borderColor,
      this.height = 60,
      this.textColor = AppTheme.Opal,
      this.backgroundColor = AppTheme.Opal,
      this.fontSize = AppTheme.CaptionFontSize11,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      height: height,
      decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: borderColor == null
                  ? BorderSide.none
                  : BorderSide(width: 1, color: borderColor!))),
      textStyle: TextStyle(
          color: textColor, fontSize: fontSize, fontWeight: fontWeight),
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
