import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:to_do_app/bindings/my_bindings.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/services/work_manager_service.dart';
import 'package:to_do_app/ui/pages/home_page.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';
import 'package:to_do_app/ui/pages/splash_screen.dart';
import 'package:to_do_app/ui/themes.dart';
import 'dart:ui';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [
      NotificationServices.init(
          onTapCallback: MyApp.navigateToNotificationScreen),
      DbHelper.init(),
      GetStorage.init(),

      // WorkManagerService().init(),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      initialBinding: MyBindings(),
      home: const SplashScreen(),
    );
  }

  static void navigateToNotificationScreen(
      NotificationResponse notificationResponse) {
    Get.to(
      () => NotificationScreen(
        payload: notificationResponse.payload!,
      ),
    );
  }
}
