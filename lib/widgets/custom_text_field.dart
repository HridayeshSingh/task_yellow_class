import 'package:flutter/material.dart';
import 'package:task_yellow_class/constants.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key key,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.iconData,
    this.labelText,
    this.obscureText,
    this.suffixIcon,
    this.isFirst,
    this.isLast,
    this.style,
    this.textAlign,
    this.maxLines,
    this.sizedBoxHeight,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String initialValue;
  final String hintText;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle style;
  final IconData iconData;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final Widget suffixIcon;
  final int maxLines;
  final double sizedBoxHeight;
  final TextEditingController controller;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      margin: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFF2A2B37),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        onSaved: onSaved,
        validator: validator,
        initialValue: initialValue,
        controller: controller,
        style: style ?? TextStyle(fontFamily: 'Poppins', fontSize: 15),
        obscureText: obscureText ?? false,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines ?? 1,
        textInputAction: textInputAction ?? TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(fontFamily: 'Poppins', fontSize: 15, color: kHintColor),
          prefixIcon: iconData != null
              ? Row(
                  children: [Icon(iconData), SizedBox(width: 14)],
                )
              : SizedBox(),
          prefixIconConstraints: iconData != null
              ? BoxConstraints.expand(width: 38, height: 38)
              : BoxConstraints.expand(width: 0, height: 0),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.all(0),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
