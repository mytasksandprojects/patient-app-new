import 'package:flutter/material.dart';
import '../utilities/colors_constant.dart';

class SmallButtonsWidget extends StatelessWidget {
  final String? title;
  final double? titleFontSize;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Function() ?onPressed;
  final double? rounderRadius;
  const SmallButtonsWidget({
    super.key,
    this.titleFontSize,
    this.rounderRadius,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    required this.title,
    required this.onPressed,
    this.height,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    bool isDisabled = onPressed == null;
    
    return SizedBox(
      height: height??40,
      width: width??double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDisabled 
                ? Colors.grey 
                : (backgroundColor ?? color ?? ColorResources.btnColor),
            disabledBackgroundColor: Colors.grey,
            side: borderColor != null 
                ? BorderSide(color: borderColor!, width: 1.5)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: rounderRadius != null 
                  ? BorderRadius.circular(rounderRadius!)
                  : BorderRadius.circular(5.0),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title ?? "", 
              style: TextStyle(
                fontSize: titleFontSize ?? 14,
                color: isDisabled 
                    ? Colors.black 
                    : (textColor ?? Colors.white),
              ),
            ),
          )),
    );
  }
}
