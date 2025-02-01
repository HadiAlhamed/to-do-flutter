import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> task = await DbHelper.query();
    taskList.assignAll(task.map((data) => Task.fromJson(data)).toList());
  }

  Future<int> addTask({
    required Task task,
  }) async {
    int id = await DbHelper.insert(task);
    getTasks();
    return id;
  }

  void deleteTask(Task task) async {
    await DbHelper.delete(task);
    getTasks();
  }

  void deleteAll() async {
    await DbHelper.deleteAll();
    getTasks();
  }

  void flipTaskCompleted(int taskId, int? isCompleted) async {
    isCompleted = isCompleted == null ? 1 : 1 - isCompleted;
    await DbHelper.update(taskId, isCompleted);
    getTasks();
  }
}
