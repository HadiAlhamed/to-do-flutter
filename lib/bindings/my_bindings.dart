import 'package:get/get.dart';
import 'package:to_do_app/controllers/task_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(TaskController());
  }
}
