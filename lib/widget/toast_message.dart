import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class IToastMsg{
  static showMessage(String message){
    toastification.show(
      title: Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
  }
}