import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  var isArabic = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadLanguage();
  }

  Future<void> _updateAppLocale() async {
    await Get.updateLocale(
      isArabic.value ? const Locale('ar', 'SA') : const Locale('en', 'US'),
    );
  }

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isArabic.value = prefs.getBool('isArabic') ?? false;
      await _updateAppLocale();
      Get.forceAppUpdate();
    } catch (e) {
      print('Error loading language: $e');
      isArabic.value = false;
    }
  }

  Future<void> toggleLanguage() async {
    isArabic.toggle();
    await saveLanguage();
    await _updateAppLocale();
    Get.forceAppUpdate();
  }

  Future<void> saveLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isArabic', isArabic.value);
    } catch (e) {
      print('Error saving language: $e');
    }
  }
}