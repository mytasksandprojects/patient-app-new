import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';
import 'controller/theme_controller.dart';
import './utilities/app_constans.dart';
import 'helpers/route_helper.dart';
import 'helpers/get_di.dart' as di;
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.put(LanguageController());
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return ToastificationWrapper(
          child: GetMaterialApp(
          title: AppConstants.appName,
          initialRoute: RouteHelper.getSplashPageRoute(),
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme ? dark : light,
          getPages: RouteHelper.routes,
          locale: LanguageController.to.isArabic.value
              ? const Locale('ar', 'SA')
              : const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'),
            Locale('en', 'US'),
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: LanguageController.to.isArabic.value
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
          ),
        );
      },
    );
  }
}