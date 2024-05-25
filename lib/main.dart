// ignore_for_file: depend_on_referenced_packages

import 'package:timezone/data/latest.dart' as tz;
import 'package:adbot/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'helper/admob_helper.dart';
import 'helper/local_notification_helper.dart';
import 'helper/local_storage.dart';
import 'helper/unity_ad.dart';
import 'services/apple_sign_in/apple_sign_in_available.dart';
import 'services/status_service_admin.dart';
import 'firebase_options.dart';
import 'helper/notification_helper.dart';
import 'routes/pages.dart';
import 'routes/routes.dart';
import 'Theme/themes.dart';
import 'utils/language/local_string.dart';
import 'utils/strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await AdManager.init();
  AdMobHelper.initialization();

  tz.initializeTimeZones();

  Stripe.publishableKey = ApiConfig.stripePublishableKey;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    // Locking Device Orientation
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  NotificationHelper.initialization();
  NotificationHelper.requestPermission();
  NotificationHelper.getBackgroundNotification();
  NotificationHelper.localNotification();
  NotificationService.init();

  StatusService.init();

  appleSignInAvailable.check();

  LocalStorage.getDailyScheduleModels();
  // main app
  runApp(const MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (_, child) => GetMaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Themes().theme,
        navigatorKey: Get.key,
        initialRoute: Routes.splashScreen,
        getPages: Pages.list,
        translations: LocalString(),
        locale: const Locale('en', 'US'),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: widget!,
          ); // Locking Device Orientation
        },
      ),
    );
  }
}
