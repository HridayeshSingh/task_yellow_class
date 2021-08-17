import 'package:flutter/material.dart';
import 'package:task_yellow_class/constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.padding,
    this.borderRadius,
    this.highlightedElevation,
    this.shapeBorder,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double highlightedElevation;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // BoxShadow(
          //     color: kButtonColor.withOpacity(0.3),
          //     blurRadius: 40,
          //     offset: Offset(0, 15)),
          BoxShadow(
              color: kButtonColor.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 3))
        ],
      ),
      child: MaterialButton(
        elevation: 10,
        highlightElevation: highlightedElevation ?? 15,
        onPressed: onPressed,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: kButtonColor,
        shape: shapeBorder ??
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 15.0)),
        child: child,
      ),
    );
  }
}
