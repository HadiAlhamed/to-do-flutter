import 'dart:developer';

import 'package:to_do_app/services/notification_services.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  Future<void> registerTask(String id, String name) async {
    await Workmanager().registerOneOffTask(
      id,
      name,
    );
  }

  Future<void> init() async {
    //initialize workmanager
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    //register your background task
    // registerTask("id1", "OneOffTask");
  }

  Future<void> cancelTask(String id) {
    return Workmanager().cancelByUniqueName(id);
  }
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputdata) {
      try {
        NotificationServices.showBasicNotification();
      } catch (err) {
        log(err.toString());
      }
      return Future.value(true);
    },
  );
}
