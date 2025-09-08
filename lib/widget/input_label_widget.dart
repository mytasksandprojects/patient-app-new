import 'package:flutter/material.dart';
import 'package:userapp/utilities/colors_constant.dart';

class InputLabel{

  static Widget  buildLabelBox(String labelText){
    return Text(labelText,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: ColorResources.primaryColor
    ),
    );
  }
}